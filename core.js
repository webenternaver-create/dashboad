// 계산·값 검사·샘플 데이터. data/kpi.json·kpi.csv는 가져오기/원본 비교용 사본이며 자동 저장하지 않습니다.
const SAMPLE=[{month:'2026-09',team:'영업A',target:10000000,actual:9000000},{month:'2026-09',team:'영업B',target:8000000,actual:8800000},{month:'2026-09',team:'영업C',target:12000000,actual:10800000},{month:'2026-10',team:'영업A',target:10000000,actual:11000000},{month:'2026-10',team:'영업B',target:8000000,actual:7200000},{month:'2026-10',team:'영업C',target:12000000,actual:12600000}];
const cloneSample=()=>SAMPLE.map(row=>({...row}));
function summarize(rows){const target=rows.reduce((s,r)=>s+r.target,0),actual=rows.reduce((s,r)=>s+r.actual,0);return{target,actual,rate:target?((actual/target)*100).toFixed(2).replace(/\.00$/,'')+'%':'목표 미설정'};}
function validateAmount(value){if(!/^\d+$/.test(String(value).trim()))throw Error('금액은 0 이상의 정수로 입력하세요.');const n=Number(value);if(!Number.isSafeInteger(n))throw Error('금액이 너무 큽니다.');return n;}
function validateRow(row){if(!/^\d{4}-(0[1-9]|1[0-2])$/.test(row.month))throw Error('월을 선택하세요.');if(!String(row.team).trim())throw Error('부서를 입력하세요.');return{month:row.month,team:String(row.team).trim(),target:validateAmount(row.target),actual:validateAmount(row.actual)};}
