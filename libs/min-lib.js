const _pipe = (...fns)=>(value)=>fns.reduce((acc,fn)=>fn(acc),value)
const _flat = v =>v 
export default _pipe