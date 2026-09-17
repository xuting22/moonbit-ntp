import fs from 'node:fs/promises';

/** Read a regular UTF-8 file with a hard allocation/read cap, including growth. */
export async function readInput(file,limit=2097152) {
  if(!file)throw Error('A file is required');
  const handle=await fs.open(file,'r');
  try {
    const stat=await handle.stat();
    if(!stat.isFile())throw Error('Input must be a regular file');
    if(stat.size>limit)throw Error('Input file exceeds 2 MiB');
    const bytes=Buffer.alloc(limit+1);
    let count=0;
    while(count<bytes.length) {
      const {bytesRead}=await handle.read(bytes,count,bytes.length-count,null);
      if(!bytesRead)break;
      count+=bytesRead;
    }
    if(count>limit)throw Error('Input file exceeds 2 MiB');
    return new TextDecoder('utf-8',{fatal:true}).decode(bytes.subarray(0,count));
  }finally {await handle.close();}
}
