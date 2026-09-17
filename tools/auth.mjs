import {createHash, createCipheriv, timingSafeEqual} from 'node:crypto';

const algorithms = {
  MD5: {hash:'md5', minimum:4, maximum:32, digest:16},
  SHA1: {hash:'sha1', minimum:4, maximum:32, digest:20},
  SHA256: {hash:'sha256', minimum:4, maximum:32, digest:20},
  SHA512: {hash:'sha512', minimum:4, maximum:32, digest:20},
  AES128: {bits:128, minimum:16, maximum:16, digest:16},
  AES256: {bits:256, minimum:32, maximum:32, digest:16},
};

function doubled(block) {
  const result=Buffer.alloc(16);
  let carry=0;
  for(let i=15;i>=0;i--) { result[i]=(block[i]<<1)|carry; carry=block[i]>>>7; }
  if(carry) result[15]^=0x87;
  return result;
}
const xor=(a,b)=>Buffer.from(a.map((byte,i)=>byte^b[i]));

/** RFC 4493 AES-CMAC, using the host's AES block cipher, never a custom AES. */
function cmac(payload,key,bits) {
  const cipher=createCipheriv('aes-'+bits+'-ecb',key,null).setAutoPadding(false);
  const encrypt=block=>cipher.update(block);
  const first=doubled(encrypt(Buffer.alloc(16))),second=doubled(first);
  const count=Math.max(1,Math.ceil(payload.length/16));
  let state=Buffer.alloc(16);
  for(let i=0;i<count-1;i++) state=encrypt(xor(state,payload.subarray(i*16,i*16+16)));
  const tail=Buffer.alloc(16),start=(count-1)*16;
  payload.copy(tail,0,start);
  const complete=payload.length>0&&payload.length%16===0;
  if(!complete) tail[payload.length-start]=0x80;
  state=encrypt(xor(state,xor(tail,complete?first:second)));
  cipher.final();
  return state;
}

/** Match beevik/ntp 1.5 key decoding and truncation. Keys remain closure-private. */
export function createAuthenticator(options) {
  if(!options||typeof options!=='object'||Array.isArray(options)||
     Object.keys(options).some(k=>!['type','key','keyID'].includes(k)))
    throw Error('Invalid NTP authentication options');
  const algorithm=Object.hasOwn(algorithms,options.type)?algorithms[options.type]:undefined;
  if(!algorithm||typeof options.key!=='string'||options.key.length>4096||
     !Number.isInteger(options.keyID)||options.keyID<0||options.keyID>65535)
    throw Error('Invalid NTP authentication algorithm, key or identifier');
  let text=options.key,isHex=false;
  if(text.startsWith('HEX:')) { isHex=true;text=text.slice(4); }
  else if(text.startsWith('ASCII:')) text=text.slice(6);
  else if(Buffer.byteLength(text,'utf8')>20) isHex=true;
  if(isHex&&(!/^[0-9a-fA-F]*$/.test(text)||text.length%2!==0)) throw Error('Invalid NTP authentication key');
  let key=Buffer.from(text,isHex?'hex':'utf8');
  if(key.length<algorithm.minimum) throw Error('Invalid NTP authentication key length');
  key=Buffer.from(key.subarray(0,algorithm.maximum));
  const digest=payload=>algorithm.hash
    ? createHash(algorithm.hash).update(key).update(payload).digest().subarray(0,algorithm.digest)
    : cmac(payload,key,algorithm.bits);
  const macLength=4+algorithm.digest,keyID=options.keyID,type=options.type;
  return Object.freeze({
    macLength,keyID,type,
    sign(payload) {
      if(!(payload instanceof Uint8Array)||payload.length<48||payload.length+macLength>65507||payload.length%4)
        throw Error('Invalid authenticated NTP payload');
      const data=Buffer.from(payload),id=Buffer.alloc(4);id.writeUInt32BE(keyID);
      return Buffer.concat([data,id,digest(data)]);
    },
    verify(datagram) {
      if(!(datagram instanceof Uint8Array)||datagram.length<48+macLength||datagram.length>65507||datagram.length%4)
        throw Error('NTP authentication failed');
      const wire=Buffer.from(datagram),cut=wire.length-macLength;
      if(wire.readUInt32BE(cut)!==keyID||!timingSafeEqual(digest(wire.subarray(0,cut)),wire.subarray(cut+4)))
        throw Error('NTP authentication failed');
      return wire.subarray(0,cut);
    }
  });
}
