const _pipe = (...fns)=>(value)=>fns.reduce((acc,fn)=>fn(acc),value)
export default _pipe