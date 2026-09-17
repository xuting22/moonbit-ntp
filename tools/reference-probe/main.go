package main
import (
 "bufio"
 "bytes"
 "encoding/hex"
 "encoding/json"
 "fmt"
 "math"
 "net"
 "os"
 "time"
 ntp "github.com/beevik/ntp"
)
type input struct {
 Name string
 Server string
 ReplyHex string
 SentUnix float64
 ReceivedUnix float64
 Version int
 ExtensionHex string
 Auth *struct {Type string; Key string; KeyID uint16}
}
type extension []byte
func (e extension) ProcessQuery(b *bytes.Buffer)error{_,err:=b.Write(e);return err}
func (e extension) ProcessResponse(b []byte)error{return nil}
type fake struct {reply,wire []byte}
func (f *fake) Write(b []byte)(int,error) {f.wire=append([]byte{},b...);return len(b),nil}
func (f *fake) Read(b []byte)(int,error) {
 r:=append([]byte{},f.reply...)
 if len(r)>=32 && len(f.wire)>=48 {copy(r[24:32],f.wire[40:48])}
 return copy(b,r),nil
}
func (f *fake) Close()error{return nil}
func (f *fake) LocalAddr()net.Addr{return &net.UDPAddr{IP:net.IPv4(127,0,0,1),Port:1234}}
func (f *fake) RemoteAddr()net.Addr{return &net.UDPAddr{IP:net.IPv4(127,0,0,1),Port:123}}
func (f *fake) SetDeadline(t time.Time)error{return nil}
func (f *fake) SetReadDeadline(t time.Time)error{return nil}
func (f *fake) SetWriteDeadline(t time.Time)error{return nil}
func stamp(s float64)time.Time{v:=math.Floor(s);return time.Unix(int64(v),int64(math.Round((s-v)*1e9)))}
func run(in input)map[string]any {
 raw,err:=hex.DecodeString(in.ReplyHex);if err!=nil{return map[string]any{"error":err.Error()}}
 conn:=&fake{reply:raw}
 calls:=0
 opt:=ntp.QueryOptions{Version:in.Version,Timeout:time.Second,
  GetSystemTime:func()time.Time{calls++;if calls==1{return stamp(in.SentUnix)};return stamp(in.ReceivedUnix)},
  Dialer:func(local,remote string)(net.Conn,error){return conn,nil},
 }
 if in.ExtensionHex!="" {raw,err:=hex.DecodeString(in.ExtensionHex);if err!=nil{panic(err)};opt.Extensions=[]ntp.Extension{extension(raw)}}
 if in.Auth!=nil {
  kinds:=map[string]ntp.AuthType{"MD5":ntp.AuthMD5,"SHA1":ntp.AuthSHA1,"SHA256":ntp.AuthSHA256,"SHA512":ntp.AuthSHA512,"AES128":ntp.AuthAES128,"AES256":ntp.AuthAES256}
  opt.Auth=ntp.AuthOptions{Type:kinds[in.Auth.Type],Key:in.Auth.Key,KeyID:in.Auth.KeyID}
 }
 address:="127.0.0.1"
 if in.Server!="" {address=in.Server;opt.Dialer=nil;opt.GetSystemTime=nil}
 result,err:=ntp.QueryWithOptions(address,opt)
 out:=map[string]any{"name":in.Name,"requestHex":hex.EncodeToString(conn.wire)}
 if err!=nil {out["error"]=err.Error();return out}
 if err=result.Validate();err!=nil{out["healthError"]=err.Error()}else{out["healthError"]=nil}
 out["value"]=map[string]any{
  "offsetSeconds":result.ClockOffset.Seconds(),"delaySeconds":result.RTT.Seconds(),
  "serverTransmitUnix":float64(result.Time.UnixNano())/1e9,
  "referenceUnix":float64(result.ReferenceTime.UnixNano())/1e9,
  "precisionSeconds":result.Precision.Seconds(),"pollSeconds":result.Poll.Seconds(),
  "minimumErrorSeconds":result.MinError.Seconds(),"rootDistanceSeconds":result.RootDistance.Seconds(),
  "referenceString":result.ReferenceString(),"referenceID":result.ReferenceID,
  "rootDelaySeconds":result.RootDelay.Seconds(),"rootDispersionSeconds":result.RootDispersion.Seconds(),
  "version":result.Version,"stratum":result.Stratum,"leap":result.Leap,
 }
 return out
}
func main(){
 scanner:=bufio.NewScanner(os.Stdin);scanner.Buffer(make([]byte,4096),1000000)
 for scanner.Scan(){
  var value input
  if err:=json.Unmarshal(scanner.Bytes(),&value);err!=nil {fmt.Println(`{"error":"bad reference input"}`);continue}
  out:=run(value);data,err:=json.Marshal(out);if err!=nil{panic(err)};fmt.Println(string(data))
 }
 if err:=scanner.Err();err!=nil{panic(err)}
}
