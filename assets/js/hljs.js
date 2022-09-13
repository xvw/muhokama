/*!
  Highlight.js v11.5.1 (git: b8f233c8e2)
  (c) 2006-2022 Ivan Sagalaev and other contributors
  License: BSD-3-Clause
 */
var hljs=function(){"use strict";var e={exports:{}};function t(e){
return e instanceof Map?e.clear=e.delete=e.set=()=>{
throw Error("map is read-only")}:e instanceof Set&&(e.add=e.clear=e.delete=()=>{
throw Error("set is read-only")
}),Object.freeze(e),Object.getOwnPropertyNames(e).forEach((n=>{var i=e[n]
;"object"!=typeof i||Object.isFrozen(i)||t(i)})),e}
e.exports=t,e.exports.default=t;var n=e.exports;class i{constructor(e){
void 0===e.data&&(e.data={}),this.data=e.data,this.isMatchIgnored=!1}
ignoreMatch(){this.isMatchIgnored=!0}}function r(e){
return e.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;").replace(/'/g,"&#x27;")
}function s(e,...t){const n=Object.create(null);for(const t in e)n[t]=e[t]
;return t.forEach((e=>{for(const t in e)n[t]=e[t]})),n}const o=e=>!!e.kind
;class a{constructor(e,t){
this.buffer="",this.classPrefix=t.classPrefix,e.walk(this)}addText(e){
this.buffer+=r(e)}openNode(e){if(!o(e))return;let t=e.kind
;t=e.sublanguage?"language-"+t:((e,{prefix:t})=>{if(e.includes(".")){
const n=e.split(".")
;return[`${t}${n.shift()}`,...n.map(((e,t)=>`${e}${"_".repeat(t+1)}`))].join(" ")
}return`${t}${e}`})(t,{prefix:this.classPrefix}),this.span(t)}closeNode(e){
o(e)&&(this.buffer+="</span>")}value(){return this.buffer}span(e){
this.buffer+=`<span class="${e}">`}}class c{constructor(){this.rootNode={
children:[]},this.stack=[this.rootNode]}get top(){
return this.stack[this.stack.length-1]}get root(){return this.rootNode}add(e){
this.top.children.push(e)}openNode(e){const t={kind:e,children:[]}
;this.add(t),this.stack.push(t)}closeNode(){
if(this.stack.length>1)return this.stack.pop()}closeAllNodes(){
for(;this.closeNode(););}toJSON(){return JSON.stringify(this.rootNode,null,4)}
walk(e){return this.constructor._walk(e,this.rootNode)}static _walk(e,t){
return"string"==typeof t?e.addText(t):t.children&&(e.openNode(t),
t.children.forEach((t=>this._walk(e,t))),e.closeNode(t)),e}static _collapse(e){
"string"!=typeof e&&e.children&&(e.children.every((e=>"string"==typeof e))?e.children=[e.children.join("")]:e.children.forEach((e=>{
c._collapse(e)})))}}class l extends c{constructor(e){super(),this.options=e}
addKeyword(e,t){""!==e&&(this.openNode(t),this.addText(e),this.closeNode())}
addText(e){""!==e&&this.add(e)}addSublanguage(e,t){const n=e.root
;n.kind=t,n.sublanguage=!0,this.add(n)}toHTML(){
return new a(this,this.options).value()}finalize(){return!0}}function g(e){
return e?"string"==typeof e?e:e.source:null}function d(e){return f("(?=",e,")")}
function u(e){return f("(?:",e,")*")}function h(e){return f("(?:",e,")?")}
function f(...e){return e.map((e=>g(e))).join("")}function p(...e){const t=(e=>{
const t=e[e.length-1]
;return"object"==typeof t&&t.constructor===Object?(e.splice(e.length-1,1),t):{}
})(e);return"("+(t.capture?"":"?:")+e.map((e=>g(e))).join("|")+")"}
function b(e){return RegExp(e.toString()+"|").exec("").length-1}
const m=/\[(?:[^\\\]]|\\.)*\]|\(\??|\\([1-9][0-9]*)|\\./
;function E(e,{joinWith:t}){let n=0;return e.map((e=>{n+=1;const t=n
;let i=g(e),r="";for(;i.length>0;){const e=m.exec(i);if(!e){r+=i;break}
r+=i.substring(0,e.index),
i=i.substring(e.index+e[0].length),"\\"===e[0][0]&&e[1]?r+="\\"+(Number(e[1])+t):(r+=e[0],
"("===e[0]&&n++)}return r})).map((e=>`(${e})`)).join(t)}
const x="[a-zA-Z]\\w*",w="[a-zA-Z_]\\w*",y="\\b\\d+(\\.\\d+)?",_="(-?)(\\b0[xX][a-fA-F0-9]+|(\\b\\d+(\\.\\d*)?|\\.\\d+)([eE][-+]?\\d+)?)",k="\\b(0b[01]+)",v={
begin:"\\\\[\\s\\S]",relevance:0},O={scope:"string",begin:"'",end:"'",
illegal:"\\n",contains:[v]},N={scope:"string",begin:'"',end:'"',illegal:"\\n",
contains:[v]},M=(e,t,n={})=>{const i=s({scope:"comment",begin:e,end:t,
contains:[]},n);i.contains.push({scope:"doctag",
begin:"[ ]*(?=(TODO|FIXME|NOTE|BUG|OPTIMIZE|HACK|XXX):)",
end:/(TODO|FIXME|NOTE|BUG|OPTIMIZE|HACK|XXX):/,excludeBegin:!0,relevance:0})
;const r=p("I","a","is","so","us","to","at","if","in","it","on",/[A-Za-z]+['](d|ve|re|ll|t|s|n)/,/[A-Za-z]+[-][a-z]+/,/[A-Za-z][a-z]{2,}/)
;return i.contains.push({begin:f(/[ ]+/,"(",r,/[.]?[:]?([.][ ]|[ ])/,"){3}")}),i
},S=M("//","$"),R=M("/\\*","\\*/"),j=M("#","$");var A=Object.freeze({
__proto__:null,MATCH_NOTHING_RE:/\b\B/,IDENT_RE:x,UNDERSCORE_IDENT_RE:w,
NUMBER_RE:y,C_NUMBER_RE:_,BINARY_NUMBER_RE:k,
RE_STARTERS_RE:"!|!=|!==|%|%=|&|&&|&=|\\*|\\*=|\\+|\\+=|,|-|-=|/=|/|:|;|<<|<<=|<=|<|===|==|=|>>>=|>>=|>=|>>>|>>|>|\\?|\\[|\\{|\\(|\\^|\\^=|\\||\\|=|\\|\\||~",
SHEBANG:(e={})=>{const t=/^#![ ]*\//
;return e.binary&&(e.begin=f(t,/.*\b/,e.binary,/\b.*/)),s({scope:"meta",begin:t,
end:/$/,relevance:0,"on:begin":(e,t)=>{0!==e.index&&t.ignoreMatch()}},e)},
BACKSLASH_ESCAPE:v,APOS_STRING_MODE:O,QUOTE_STRING_MODE:N,PHRASAL_WORDS_MODE:{
begin:/\b(a|an|the|are|I'm|isn't|don't|doesn't|won't|but|just|should|pretty|simply|enough|gonna|going|wtf|so|such|will|you|your|they|like|more)\b/
},COMMENT:M,C_LINE_COMMENT_MODE:S,C_BLOCK_COMMENT_MODE:R,HASH_COMMENT_MODE:j,
NUMBER_MODE:{scope:"number",begin:y,relevance:0},C_NUMBER_MODE:{scope:"number",
begin:_,relevance:0},BINARY_NUMBER_MODE:{scope:"number",begin:k,relevance:0},
REGEXP_MODE:{begin:/(?=\/[^/\n]*\/)/,contains:[{scope:"regexp",begin:/\//,
end:/\/[gimuy]*/,illegal:/\n/,contains:[v,{begin:/\[/,end:/\]/,relevance:0,
contains:[v]}]}]},TITLE_MODE:{scope:"title",begin:x,relevance:0},
UNDERSCORE_TITLE_MODE:{scope:"title",begin:w,relevance:0},METHOD_GUARD:{
begin:"\\.\\s*[a-zA-Z_]\\w*",relevance:0},END_SAME_AS_BEGIN:e=>Object.assign(e,{
"on:begin":(e,t)=>{t.data._beginMatch=e[1]},"on:end":(e,t)=>{
t.data._beginMatch!==e[1]&&t.ignoreMatch()}})});function I(e,t){
"."===e.input[e.index-1]&&t.ignoreMatch()}function T(e,t){
void 0!==e.className&&(e.scope=e.className,delete e.className)}function L(e,t){
t&&e.beginKeywords&&(e.begin="\\b("+e.beginKeywords.split(" ").join("|")+")(?!\\.)(?=\\b|\\s)",
e.__beforeBegin=I,e.keywords=e.keywords||e.beginKeywords,delete e.beginKeywords,
void 0===e.relevance&&(e.relevance=0))}function B(e,t){
Array.isArray(e.illegal)&&(e.illegal=p(...e.illegal))}function D(e,t){
if(e.match){
if(e.begin||e.end)throw Error("begin & end are not supported with match")
;e.begin=e.match,delete e.match}}function H(e,t){
void 0===e.relevance&&(e.relevance=1)}const P=(e,t)=>{if(!e.beforeMatch)return
;if(e.starts)throw Error("beforeMatch cannot be used with starts")
;const n=Object.assign({},e);Object.keys(e).forEach((t=>{delete e[t]
})),e.keywords=n.keywords,e.begin=f(n.beforeMatch,d(n.begin)),e.starts={
relevance:0,contains:[Object.assign(n,{endsParent:!0})]
},e.relevance=0,delete n.beforeMatch
},C=["of","and","for","in","not","or","if","then","parent","list","value"]
;function $(e,t,n="keyword"){const i=Object.create(null)
;return"string"==typeof e?r(n,e.split(" ")):Array.isArray(e)?r(n,e):Object.keys(e).forEach((n=>{
Object.assign(i,$(e[n],t,n))})),i;function r(e,n){
t&&(n=n.map((e=>e.toLowerCase()))),n.forEach((t=>{const n=t.split("|")
;i[n[0]]=[e,U(n[0],n[1])]}))}}function U(e,t){
return t?Number(t):(e=>C.includes(e.toLowerCase()))(e)?0:1}const z={},K=e=>{
console.error(e)},W=(e,...t)=>{console.log("WARN: "+e,...t)},X=(e,t)=>{
z[`${e}/${t}`]||(console.log(`Deprecated as of ${e}. ${t}`),z[`${e}/${t}`]=!0)
},G=Error();function Z(e,t,{key:n}){let i=0;const r=e[n],s={},o={}
;for(let e=1;e<=t.length;e++)o[e+i]=r[e],s[e+i]=!0,i+=b(t[e-1])
;e[n]=o,e[n]._emit=s,e[n]._multi=!0}function F(e){(e=>{
e.scope&&"object"==typeof e.scope&&null!==e.scope&&(e.beginScope=e.scope,
delete e.scope)})(e),"string"==typeof e.beginScope&&(e.beginScope={
_wrap:e.beginScope}),"string"==typeof e.endScope&&(e.endScope={_wrap:e.endScope
}),(e=>{if(Array.isArray(e.begin)){
if(e.skip||e.excludeBegin||e.returnBegin)throw K("skip, excludeBegin, returnBegin not compatible with beginScope: {}"),
G
;if("object"!=typeof e.beginScope||null===e.beginScope)throw K("beginScope must be object"),
G;Z(e,e.begin,{key:"beginScope"}),e.begin=E(e.begin,{joinWith:""})}})(e),(e=>{
if(Array.isArray(e.end)){
if(e.skip||e.excludeEnd||e.returnEnd)throw K("skip, excludeEnd, returnEnd not compatible with endScope: {}"),
G
;if("object"!=typeof e.endScope||null===e.endScope)throw K("endScope must be object"),
G;Z(e,e.end,{key:"endScope"}),e.end=E(e.end,{joinWith:""})}})(e)}function V(e){
function t(t,n){
return RegExp(g(t),"m"+(e.case_insensitive?"i":"")+(e.unicodeRegex?"u":"")+(n?"g":""))
}class n{constructor(){
this.matchIndexes={},this.regexes=[],this.matchAt=1,this.position=0}
addRule(e,t){
t.position=this.position++,this.matchIndexes[this.matchAt]=t,this.regexes.push([t,e]),
this.matchAt+=b(e)+1}compile(){0===this.regexes.length&&(this.exec=()=>null)
;const e=this.regexes.map((e=>e[1]));this.matcherRe=t(E(e,{joinWith:"|"
}),!0),this.lastIndex=0}exec(e){this.matcherRe.lastIndex=this.lastIndex
;const t=this.matcherRe.exec(e);if(!t)return null
;const n=t.findIndex(((e,t)=>t>0&&void 0!==e)),i=this.matchIndexes[n]
;return t.splice(0,n),Object.assign(t,i)}}class i{constructor(){
this.rules=[],this.multiRegexes=[],
this.count=0,this.lastIndex=0,this.regexIndex=0}getMatcher(e){
if(this.multiRegexes[e])return this.multiRegexes[e];const t=new n
;return this.rules.slice(e).forEach((([e,n])=>t.addRule(e,n))),
t.compile(),this.multiRegexes[e]=t,t}resumingScanAtSamePosition(){
return 0!==this.regexIndex}considerAll(){this.regexIndex=0}addRule(e,t){
this.rules.push([e,t]),"begin"===t.type&&this.count++}exec(e){
const t=this.getMatcher(this.regexIndex);t.lastIndex=this.lastIndex
;let n=t.exec(e)
;if(this.resumingScanAtSamePosition())if(n&&n.index===this.lastIndex);else{
const t=this.getMatcher(0);t.lastIndex=this.lastIndex+1,n=t.exec(e)}
return n&&(this.regexIndex+=n.position+1,
this.regexIndex===this.count&&this.considerAll()),n}}
if(e.compilerExtensions||(e.compilerExtensions=[]),
e.contains&&e.contains.includes("self"))throw Error("ERR: contains `self` is not supported at the top-level of a language.  See documentation.")
;return e.classNameAliases=s(e.classNameAliases||{}),function n(r,o){const a=r
;if(r.isCompiled)return a
;[T,D,F,P].forEach((e=>e(r,o))),e.compilerExtensions.forEach((e=>e(r,o))),
r.__beforeBegin=null,[L,B,H].forEach((e=>e(r,o))),r.isCompiled=!0;let c=null
;return"object"==typeof r.keywords&&r.keywords.$pattern&&(r.keywords=Object.assign({},r.keywords),
c=r.keywords.$pattern,
delete r.keywords.$pattern),c=c||/\w+/,r.keywords&&(r.keywords=$(r.keywords,e.case_insensitive)),
a.keywordPatternRe=t(c,!0),
o&&(r.begin||(r.begin=/\B|\b/),a.beginRe=t(a.begin),r.end||r.endsWithParent||(r.end=/\B|\b/),
r.end&&(a.endRe=t(a.end)),
a.terminatorEnd=g(a.end)||"",r.endsWithParent&&o.terminatorEnd&&(a.terminatorEnd+=(r.end?"|":"")+o.terminatorEnd)),
r.illegal&&(a.illegalRe=t(r.illegal)),
r.contains||(r.contains=[]),r.contains=[].concat(...r.contains.map((e=>(e=>(e.variants&&!e.cachedVariants&&(e.cachedVariants=e.variants.map((t=>s(e,{
variants:null},t)))),e.cachedVariants?e.cachedVariants:q(e)?s(e,{
starts:e.starts?s(e.starts):null
}):Object.isFrozen(e)?s(e):e))("self"===e?r:e)))),r.contains.forEach((e=>{n(e,a)
})),r.starts&&n(r.starts,o),a.matcher=(e=>{const t=new i
;return e.contains.forEach((e=>t.addRule(e.begin,{rule:e,type:"begin"
}))),e.terminatorEnd&&t.addRule(e.terminatorEnd,{type:"end"
}),e.illegal&&t.addRule(e.illegal,{type:"illegal"}),t})(a),a}(e)}function q(e){
return!!e&&(e.endsWithParent||q(e.starts))}class J extends Error{
constructor(e,t){super(e),this.name="HTMLInjectionError",this.html=t}}
const Y=r,Q=s,ee=Symbol("nomatch");var te=(e=>{
const t=Object.create(null),r=Object.create(null),s=[];let o=!0
;const a="Could not find the language '{}', did you forget to load/include a language module?",c={
disableAutodetect:!0,name:"Plain text",contains:[]};let g={
ignoreUnescapedHTML:!1,throwUnescapedHTML:!1,noHighlightRe:/^(no-?highlight)$/i,
languageDetectRe:/\blang(?:uage)?-([\w-]+)\b/i,classPrefix:"hljs-",
cssSelector:"pre code",languages:null,__emitter:l};function b(e){
return g.noHighlightRe.test(e)}function m(e,t,n){let i="",r=""
;"object"==typeof t?(i=e,
n=t.ignoreIllegals,r=t.language):(X("10.7.0","highlight(lang, code, ...args) has been deprecated."),
X("10.7.0","Please use highlight(code, options) instead.\nhttps://github.com/highlightjs/highlight.js/issues/2277"),
r=e,i=t),void 0===n&&(n=!0);const s={code:i,language:r};N("before:highlight",s)
;const o=s.result?s.result:E(s.language,s.code,n)
;return o.code=s.code,N("after:highlight",o),o}function E(e,n,r,s){
const c=Object.create(null);function l(){if(!O.keywords)return void M.addText(S)
;let e=0;O.keywordPatternRe.lastIndex=0;let t=O.keywordPatternRe.exec(S),n=""
;for(;t;){n+=S.substring(e,t.index)
;const r=y.case_insensitive?t[0].toLowerCase():t[0],s=(i=r,O.keywords[i]);if(s){
const[e,i]=s
;if(M.addText(n),n="",c[r]=(c[r]||0)+1,c[r]<=7&&(R+=i),e.startsWith("_"))n+=t[0];else{
const n=y.classNameAliases[e]||e;M.addKeyword(t[0],n)}}else n+=t[0]
;e=O.keywordPatternRe.lastIndex,t=O.keywordPatternRe.exec(S)}var i
;n+=S.substr(e),M.addText(n)}function d(){null!=O.subLanguage?(()=>{
if(""===S)return;let e=null;if("string"==typeof O.subLanguage){
if(!t[O.subLanguage])return void M.addText(S)
;e=E(O.subLanguage,S,!0,N[O.subLanguage]),N[O.subLanguage]=e._top
}else e=x(S,O.subLanguage.length?O.subLanguage:null)
;O.relevance>0&&(R+=e.relevance),M.addSublanguage(e._emitter,e.language)
})():l(),S=""}function u(e,t){let n=1;const i=t.length-1;for(;n<=i;){
if(!e._emit[n]){n++;continue}const i=y.classNameAliases[e[n]]||e[n],r=t[n]
;i?M.addKeyword(r,i):(S=r,l(),S=""),n++}}function h(e,t){
return e.scope&&"string"==typeof e.scope&&M.openNode(y.classNameAliases[e.scope]||e.scope),
e.beginScope&&(e.beginScope._wrap?(M.addKeyword(S,y.classNameAliases[e.beginScope._wrap]||e.beginScope._wrap),
S=""):e.beginScope._multi&&(u(e.beginScope,t),S="")),O=Object.create(e,{parent:{
value:O}}),O}function f(e,t,n){let r=((e,t)=>{const n=e&&e.exec(t)
;return n&&0===n.index})(e.endRe,n);if(r){if(e["on:end"]){const n=new i(e)
;e["on:end"](t,n),n.isMatchIgnored&&(r=!1)}if(r){
for(;e.endsParent&&e.parent;)e=e.parent;return e}}
if(e.endsWithParent)return f(e.parent,t,n)}function p(e){
return 0===O.matcher.regexIndex?(S+=e[0],1):(I=!0,0)}function b(e){
const t=e[0],i=n.substr(e.index),r=f(O,e,i);if(!r)return ee;const s=O
;O.endScope&&O.endScope._wrap?(d(),
M.addKeyword(t,O.endScope._wrap)):O.endScope&&O.endScope._multi?(d(),
u(O.endScope,e)):s.skip?S+=t:(s.returnEnd||s.excludeEnd||(S+=t),
d(),s.excludeEnd&&(S=t));do{
O.scope&&M.closeNode(),O.skip||O.subLanguage||(R+=O.relevance),O=O.parent
}while(O!==r.parent);return r.starts&&h(r.starts,e),s.returnEnd?0:t.length}
let m={};function w(t,s){const a=s&&s[0];if(S+=t,null==a)return d(),0
;if("begin"===m.type&&"end"===s.type&&m.index===s.index&&""===a){
if(S+=n.slice(s.index,s.index+1),!o){const t=Error(`0 width match regex (${e})`)
;throw t.languageName=e,t.badRule=m.rule,t}return 1}
if(m=s,"begin"===s.type)return(e=>{
const t=e[0],n=e.rule,r=new i(n),s=[n.__beforeBegin,n["on:begin"]]
;for(const n of s)if(n&&(n(e,r),r.isMatchIgnored))return p(t)
;return n.skip?S+=t:(n.excludeBegin&&(S+=t),
d(),n.returnBegin||n.excludeBegin||(S=t)),h(n,e),n.returnBegin?0:t.length})(s)
;if("illegal"===s.type&&!r){
const e=Error('Illegal lexeme "'+a+'" for mode "'+(O.scope||"<unnamed>")+'"')
;throw e.mode=O,e}if("end"===s.type){const e=b(s);if(e!==ee)return e}
if("illegal"===s.type&&""===a)return 1
;if(A>1e5&&A>3*s.index)throw Error("potential infinite loop, way more iterations than matches")
;return S+=a,a.length}const y=k(e)
;if(!y)throw K(a.replace("{}",e)),Error('Unknown language: "'+e+'"')
;const _=V(y);let v="",O=s||_;const N={},M=new g.__emitter(g);(()=>{const e=[]
;for(let t=O;t!==y;t=t.parent)t.scope&&e.unshift(t.scope)
;e.forEach((e=>M.openNode(e)))})();let S="",R=0,j=0,A=0,I=!1;try{
for(O.matcher.considerAll();;){
A++,I?I=!1:O.matcher.considerAll(),O.matcher.lastIndex=j
;const e=O.matcher.exec(n);if(!e)break;const t=w(n.substring(j,e.index),e)
;j=e.index+t}return w(n.substr(j)),M.closeAllNodes(),M.finalize(),v=M.toHTML(),{
language:e,value:v,relevance:R,illegal:!1,_emitter:M,_top:O}}catch(t){
if(t.message&&t.message.includes("Illegal"))return{language:e,value:Y(n),
illegal:!0,relevance:0,_illegalBy:{message:t.message,index:j,
context:n.slice(j-100,j+100),mode:t.mode,resultSoFar:v},_emitter:M};if(o)return{
language:e,value:Y(n),illegal:!1,relevance:0,errorRaised:t,_emitter:M,_top:O}
;throw t}}function x(e,n){n=n||g.languages||Object.keys(t);const i=(e=>{
const t={value:Y(e),illegal:!1,relevance:0,_top:c,_emitter:new g.__emitter(g)}
;return t._emitter.addText(e),t})(e),r=n.filter(k).filter(O).map((t=>E(t,e,!1)))
;r.unshift(i);const s=r.sort(((e,t)=>{
if(e.relevance!==t.relevance)return t.relevance-e.relevance
;if(e.language&&t.language){if(k(e.language).supersetOf===t.language)return 1
;if(k(t.language).supersetOf===e.language)return-1}return 0})),[o,a]=s,l=o
;return l.secondBest=a,l}function w(e){let t=null;const n=(e=>{
let t=e.className+" ";t+=e.parentNode?e.parentNode.className:""
;const n=g.languageDetectRe.exec(t);if(n){const t=k(n[1])
;return t||(W(a.replace("{}",n[1])),
W("Falling back to no-highlight mode for this block.",e)),t?n[1]:"no-highlight"}
return t.split(/\s+/).find((e=>b(e)||k(e)))})(e);if(b(n))return
;if(N("before:highlightElement",{el:e,language:n
}),e.children.length>0&&(g.ignoreUnescapedHTML||(console.warn("One of your code blocks includes unescaped HTML. This is a potentially serious security risk."),
console.warn("https://github.com/highlightjs/highlight.js/wiki/security"),
console.warn("The element with unescaped HTML:"),
console.warn(e)),g.throwUnescapedHTML))throw new J("One of your code blocks includes unescaped HTML.",e.innerHTML)
;t=e;const i=t.textContent,s=n?m(i,{language:n,ignoreIllegals:!0}):x(i)
;e.innerHTML=s.value,((e,t,n)=>{const i=t&&r[t]||n
;e.classList.add("hljs"),e.classList.add("language-"+i)
})(e,n,s.language),e.result={language:s.language,re:s.relevance,
relevance:s.relevance},s.secondBest&&(e.secondBest={
language:s.secondBest.language,relevance:s.secondBest.relevance
}),N("after:highlightElement",{el:e,result:s,text:i})}let y=!1;function _(){
"loading"!==document.readyState?document.querySelectorAll(g.cssSelector).forEach(w):y=!0
}function k(e){return e=(e||"").toLowerCase(),t[e]||t[r[e]]}
function v(e,{languageName:t}){"string"==typeof e&&(e=[e]),e.forEach((e=>{
r[e.toLowerCase()]=t}))}function O(e){const t=k(e)
;return t&&!t.disableAutodetect}function N(e,t){const n=e;s.forEach((e=>{
e[n]&&e[n](t)}))}
"undefined"!=typeof window&&window.addEventListener&&window.addEventListener("DOMContentLoaded",(()=>{
y&&_()}),!1),Object.assign(e,{highlight:m,highlightAuto:x,highlightAll:_,
highlightElement:w,
highlightBlock:e=>(X("10.7.0","highlightBlock will be removed entirely in v12.0"),
X("10.7.0","Please use highlightElement now."),w(e)),configure:e=>{g=Q(g,e)},
initHighlighting:()=>{
_(),X("10.6.0","initHighlighting() deprecated.  Use highlightAll() now.")},
initHighlightingOnLoad:()=>{
_(),X("10.6.0","initHighlightingOnLoad() deprecated.  Use highlightAll() now.")
},registerLanguage:(n,i)=>{let r=null;try{r=i(e)}catch(e){
if(K("Language definition for '{}' could not be registered.".replace("{}",n)),
!o)throw e;K(e),r=c}
r.name||(r.name=n),t[n]=r,r.rawDefinition=i.bind(null,e),r.aliases&&v(r.aliases,{
languageName:n})},unregisterLanguage:e=>{delete t[e]
;for(const t of Object.keys(r))r[t]===e&&delete r[t]},
listLanguages:()=>Object.keys(t),getLanguage:k,registerAliases:v,
autoDetection:O,inherit:Q,addPlugin:e=>{(e=>{
e["before:highlightBlock"]&&!e["before:highlightElement"]&&(e["before:highlightElement"]=t=>{
e["before:highlightBlock"](Object.assign({block:t.el},t))
}),e["after:highlightBlock"]&&!e["after:highlightElement"]&&(e["after:highlightElement"]=t=>{
e["after:highlightBlock"](Object.assign({block:t.el},t))})})(e),s.push(e)}
}),e.debugMode=()=>{o=!1},e.safeMode=()=>{o=!0
},e.versionString="11.5.1",e.regex={concat:f,lookahead:d,either:p,optional:h,
anyNumberOfTimes:u};for(const e in A)"object"==typeof A[e]&&n(A[e])
;return Object.assign(e,A),e})({});return te}()
;"object"==typeof exports&&"undefined"!=typeof module&&(module.exports=hljs);/*! `nginx` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{const n=e.regex,a={
className:"variable",variants:[{begin:/\$\d+/},{begin:/\$\{\w+\}/},{
begin:n.concat(/[$@]/,e.UNDERSCORE_IDENT_RE)}]},s={endsWithParent:!0,keywords:{
$pattern:/[a-z_]{2,}|\/dev\/poll/,
literal:["on","off","yes","no","true","false","none","blocked","debug","info","notice","warn","error","crit","select","break","last","permanent","redirect","kqueue","rtsig","epoll","poll","/dev/poll"]
},relevance:0,illegal:"=>",contains:[e.HASH_COMMENT_MODE,{className:"string",
contains:[e.BACKSLASH_ESCAPE,a],variants:[{begin:/"/,end:/"/},{begin:/'/,end:/'/
}]},{begin:"([a-z]+):/",end:"\\s",endsWithParent:!0,excludeEnd:!0,contains:[a]
},{className:"regexp",contains:[e.BACKSLASH_ESCAPE,a],variants:[{begin:"\\s\\^",
end:"\\s|\\{|;",returnEnd:!0},{begin:"~\\*?\\s+",end:"\\s|\\{|;",returnEnd:!0},{
begin:"\\*(\\.[a-z\\-]+)+"},{begin:"([a-z\\-]+\\.)+\\*"}]},{className:"number",
begin:"\\b\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}(:\\d{1,5})?\\b"},{
className:"number",begin:"\\b\\d+[kKmMgGdshdwy]?\\b",relevance:0},a]};return{
name:"Nginx config",aliases:["nginxconf"],contains:[e.HASH_COMMENT_MODE,{
beginKeywords:"upstream location",end:/;|\{/,contains:s.contains,keywords:{
section:"upstream location"}},{className:"section",
begin:n.concat(e.UNDERSCORE_IDENT_RE+n.lookahead(/\s+\{/)),relevance:0},{
begin:n.lookahead(e.UNDERSCORE_IDENT_RE+"\\s"),end:";|\\{",contains:[{
className:"attribute",begin:e.UNDERSCORE_IDENT_RE,starts:s}],relevance:0}],
illegal:"[^\\s\\}\\{]"}}})();hljs.registerLanguage("nginx",e)})();/*! `swift` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";function e(e){
return e?"string"==typeof e?e:e.source:null}function a(e){return t("(?=",e,")")}
function t(...a){return a.map((a=>e(a))).join("")}function n(...a){const t=(e=>{
const a=e[e.length-1]
;return"object"==typeof a&&a.constructor===Object?(e.splice(e.length-1,1),a):{}
})(a);return"("+(t.capture?"":"?:")+a.map((a=>e(a))).join("|")+")"}
const i=e=>t(/\b/,e,/\w$/.test(e)?/\b/:/\B/),s=["Protocol","Type"].map(i),u=["init","self"].map(i),c=["Any","Self"],r=["actor","associatedtype","async","await",/as\?/,/as!/,"as","break","case","catch","class","continue","convenience","default","defer","deinit","didSet","do","dynamic","else","enum","extension","fallthrough",/fileprivate\(set\)/,"fileprivate","final","for","func","get","guard","if","import","indirect","infix",/init\?/,/init!/,"inout",/internal\(set\)/,"internal","in","is","isolated","nonisolated","lazy","let","mutating","nonmutating",/open\(set\)/,"open","operator","optional","override","postfix","precedencegroup","prefix",/private\(set\)/,"private","protocol",/public\(set\)/,"public","repeat","required","rethrows","return","set","some","static","struct","subscript","super","switch","throws","throw",/try\?/,/try!/,"try","typealias",/unowned\(safe\)/,/unowned\(unsafe\)/,"unowned","var","weak","where","while","willSet"],o=["false","nil","true"],l=["assignment","associativity","higherThan","left","lowerThan","none","right"],m=["#colorLiteral","#column","#dsohandle","#else","#elseif","#endif","#error","#file","#fileID","#fileLiteral","#filePath","#function","#if","#imageLiteral","#keyPath","#line","#selector","#sourceLocation","#warn_unqualified_access","#warning"],p=["abs","all","any","assert","assertionFailure","debugPrint","dump","fatalError","getVaList","isKnownUniquelyReferenced","max","min","numericCast","pointwiseMax","pointwiseMin","precondition","preconditionFailure","print","readLine","repeatElement","sequence","stride","swap","swift_unboxFromSwiftValueWithType","transcode","type","unsafeBitCast","unsafeDowncast","withExtendedLifetime","withUnsafeMutablePointer","withUnsafePointer","withVaList","withoutActuallyEscaping","zip"],d=n(/[/=\-+!*%<>&|^~?]/,/[\u00A1-\u00A7]/,/[\u00A9\u00AB]/,/[\u00AC\u00AE]/,/[\u00B0\u00B1]/,/[\u00B6\u00BB\u00BF\u00D7\u00F7]/,/[\u2016-\u2017]/,/[\u2020-\u2027]/,/[\u2030-\u203E]/,/[\u2041-\u2053]/,/[\u2055-\u205E]/,/[\u2190-\u23FF]/,/[\u2500-\u2775]/,/[\u2794-\u2BFF]/,/[\u2E00-\u2E7F]/,/[\u3001-\u3003]/,/[\u3008-\u3020]/,/[\u3030]/),F=n(d,/[\u0300-\u036F]/,/[\u1DC0-\u1DFF]/,/[\u20D0-\u20FF]/,/[\uFE00-\uFE0F]/,/[\uFE20-\uFE2F]/),b=t(d,F,"*"),h=n(/[a-zA-Z_]/,/[\u00A8\u00AA\u00AD\u00AF\u00B2-\u00B5\u00B7-\u00BA]/,/[\u00BC-\u00BE\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u00FF]/,/[\u0100-\u02FF\u0370-\u167F\u1681-\u180D\u180F-\u1DBF]/,/[\u1E00-\u1FFF]/,/[\u200B-\u200D\u202A-\u202E\u203F-\u2040\u2054\u2060-\u206F]/,/[\u2070-\u20CF\u2100-\u218F\u2460-\u24FF\u2776-\u2793]/,/[\u2C00-\u2DFF\u2E80-\u2FFF]/,/[\u3004-\u3007\u3021-\u302F\u3031-\u303F\u3040-\uD7FF]/,/[\uF900-\uFD3D\uFD40-\uFDCF\uFDF0-\uFE1F\uFE30-\uFE44]/,/[\uFE47-\uFEFE\uFF00-\uFFFD]/),f=n(h,/\d/,/[\u0300-\u036F\u1DC0-\u1DFF\u20D0-\u20FF\uFE20-\uFE2F]/),w=t(h,f,"*"),y=t(/[A-Z]/,f,"*"),g=["autoclosure",t(/convention\(/,n("swift","block","c"),/\)/),"discardableResult","dynamicCallable","dynamicMemberLookup","escaping","frozen","GKInspectable","IBAction","IBDesignable","IBInspectable","IBOutlet","IBSegueAction","inlinable","main","nonobjc","NSApplicationMain","NSCopying","NSManaged",t(/objc\(/,w,/\)/),"objc","objcMembers","propertyWrapper","requires_stored_property_inits","resultBuilder","testable","UIApplicationMain","unknown","usableFromInline"],E=["iOS","iOSApplicationExtension","macOS","macOSApplicationExtension","macCatalyst","macCatalystApplicationExtension","watchOS","watchOSApplicationExtension","tvOS","tvOSApplicationExtension","swift"]
;return e=>{const d={match:/\s+/,relevance:0},h=e.COMMENT("/\\*","\\*/",{
contains:["self"]}),v=[e.C_LINE_COMMENT_MODE,h],A={match:[/\./,n(...s,...u)],
className:{2:"keyword"}},N={match:t(/\./,n(...r)),relevance:0
},C=r.filter((e=>"string"==typeof e)).concat(["_|0"]),D={variants:[{
className:"keyword",
match:n(...r.filter((e=>"string"!=typeof e)).concat(c).map(i),...u)}]},k={
$pattern:n(/\b\w+/,/#\w+/),keyword:C.concat(m),literal:o},B=[A,N,D],_=[{
match:t(/\./,n(...p)),relevance:0},{className:"built_in",
match:t(/\b/,n(...p),/(?=\()/)}],S={match:/->/,relevance:0},M=[S,{
className:"operator",relevance:0,variants:[{match:b},{match:`\\.(\\.|${F})+`}]
}],x="([0-9a-fA-F]_*)+",I={className:"number",relevance:0,variants:[{
match:"\\b(([0-9]_*)+)(\\.(([0-9]_*)+))?([eE][+-]?(([0-9]_*)+))?\\b"},{
match:`\\b0x(${x})(\\.(${x}))?([pP][+-]?(([0-9]_*)+))?\\b`},{
match:/\b0o([0-7]_*)+\b/},{match:/\b0b([01]_*)+\b/}]},L=(e="")=>({
className:"subst",variants:[{match:t(/\\/,e,/[0\\tnr"']/)},{
match:t(/\\/,e,/u\{[0-9a-fA-F]{1,8}\}/)}]}),O=(e="")=>({className:"subst",
match:t(/\\/,e,/[\t ]*(?:[\r\n]|\r\n)/)}),T=(e="")=>({className:"subst",
label:"interpol",begin:t(/\\/,e,/\(/),end:/\)/}),$=(e="")=>({begin:t(e,/"""/),
end:t(/"""/,e),contains:[L(e),O(e),T(e)]}),j=(e="")=>({begin:t(e,/"/),
end:t(/"/,e),contains:[L(e),T(e)]}),P={className:"string",
variants:[$(),$("#"),$("##"),$("###"),j(),j("#"),j("##"),j("###")]},K={
match:t(/`/,w,/`/)},z=[K,{className:"variable",match:/\$\d+/},{
className:"variable",match:`\\$${f}+`}],q=[{match:/(@|#(un)?)available/,
className:"keyword",starts:{contains:[{begin:/\(/,end:/\)/,keywords:E,
contains:[...M,I,P]}]}},{className:"keyword",match:t(/@/,n(...g))},{
className:"meta",match:t(/@/,w)}],U={match:a(/\b[A-Z]/),relevance:0,contains:[{
className:"type",
match:t(/(AV|CA|CF|CG|CI|CL|CM|CN|CT|MK|MP|MTK|MTL|NS|SCN|SK|UI|WK|XC)/,f,"+")
},{className:"type",match:y,relevance:0},{match:/[?!]+/,relevance:0},{
match:/\.\.\./,relevance:0},{match:t(/\s+&\s+/,a(y)),relevance:0}]},Z={
begin:/</,end:/>/,keywords:k,contains:[...v,...B,...q,S,U]};U.contains.push(Z)
;const V={begin:/\(/,end:/\)/,relevance:0,keywords:k,contains:["self",{
match:t(w,/\s*:/),keywords:"_|0",relevance:0
},...v,...B,..._,...M,I,P,...z,...q,U]},W={begin:/</,end:/>/,contains:[...v,U]
},G={begin:/\(/,end:/\)/,keywords:k,contains:[{
begin:n(a(t(w,/\s*:/)),a(t(w,/\s+/,w,/\s*:/))),end:/:/,relevance:0,contains:[{
className:"keyword",match:/\b_\b/},{className:"params",match:w}]
},...v,...B,...M,I,P,...q,U,V],endsParent:!0,illegal:/["']/},R={
match:[/func/,/\s+/,n(K.match,w,b)],className:{1:"keyword",3:"title.function"},
contains:[W,G,d],illegal:[/\[/,/%/]},X={
match:[/\b(?:subscript|init[?!]?)/,/\s*(?=[<(])/],className:{1:"keyword"},
contains:[W,G,d],illegal:/\[|%/},H={match:[/operator/,/\s+/,b],className:{
1:"keyword",3:"title"}},J={begin:[/precedencegroup/,/\s+/,y],className:{
1:"keyword",3:"title"},contains:[U],keywords:[...l,...o],end:/}/}
;for(const e of P.variants){const a=e.contains.find((e=>"interpol"===e.label))
;a.keywords=k;const t=[...B,..._,...M,I,P,...z];a.contains=[...t,{begin:/\(/,
end:/\)/,contains:["self",...t]}]}return{name:"Swift",keywords:k,
contains:[...v,R,X,{beginKeywords:"struct protocol class extension enum actor",
end:"\\{",excludeEnd:!0,keywords:k,contains:[e.inherit(e.TITLE_MODE,{
className:"title.class",begin:/[A-Za-z$_][\u00C0-\u02B80-9A-Za-z$_]*/}),...B]
},H,J,{beginKeywords:"import",end:/$/,contains:[...v],relevance:0
},...B,..._,...M,I,P,...z,...q,U,V]}}})();hljs.registerLanguage("swift",e)})();/*! `latex` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{const n=[{begin:/\^{6}[0-9a-f]{6}/},{
begin:/\^{5}[0-9a-f]{5}/},{begin:/\^{4}[0-9a-f]{4}/},{begin:/\^{3}[0-9a-f]{3}/
},{begin:/\^{2}[0-9a-f]{2}/},{begin:/\^{2}[\u0000-\u007f]/}],a=[{
className:"keyword",begin:/\\/,relevance:0,contains:[{endsParent:!0,
begin:e.regex.either(...["(?:NeedsTeXFormat|RequirePackage|GetIdInfo)","Provides(?:Expl)?(?:Package|Class|File)","(?:DeclareOption|ProcessOptions)","(?:documentclass|usepackage|input|include)","makeat(?:letter|other)","ExplSyntax(?:On|Off)","(?:new|renew|provide)?command","(?:re)newenvironment","(?:New|Renew|Provide|Declare)(?:Expandable)?DocumentCommand","(?:New|Renew|Provide|Declare)DocumentEnvironment","(?:(?:e|g|x)?def|let)","(?:begin|end)","(?:part|chapter|(?:sub){0,2}section|(?:sub)?paragraph)","caption","(?:label|(?:eq|page|name)?ref|(?:paren|foot|super)?cite)","(?:alpha|beta|[Gg]amma|[Dd]elta|(?:var)?epsilon|zeta|eta|[Tt]heta|vartheta)","(?:iota|(?:var)?kappa|[Ll]ambda|mu|nu|[Xx]i|[Pp]i|varpi|(?:var)rho)","(?:[Ss]igma|varsigma|tau|[Uu]psilon|[Pp]hi|varphi|chi|[Pp]si|[Oo]mega)","(?:frac|sum|prod|lim|infty|times|sqrt|leq|geq|left|right|middle|[bB]igg?)","(?:[lr]angle|q?quad|[lcvdi]?dots|d?dot|hat|tilde|bar)"].map((e=>e+"(?![a-zA-Z@:_])")))
},{endsParent:!0,
begin:RegExp(["(?:__)?[a-zA-Z]{2,}_[a-zA-Z](?:_?[a-zA-Z])+:[a-zA-Z]*","[lgc]__?[a-zA-Z](?:_?[a-zA-Z])*_[a-zA-Z]{2,}","[qs]__?[a-zA-Z](?:_?[a-zA-Z])+","use(?:_i)?:[a-zA-Z]*","(?:else|fi|or):","(?:if|cs|exp):w","(?:hbox|vbox):n","::[a-zA-Z]_unbraced","::[a-zA-Z:]"].map((e=>e+"(?![a-zA-Z:_])")).join("|"))
},{endsParent:!0,variants:n},{endsParent:!0,relevance:0,variants:[{
begin:/[a-zA-Z@]+/},{begin:/[^a-zA-Z@]?/}]}]},{className:"params",relevance:0,
begin:/#+\d?/},{variants:n},{className:"built_in",relevance:0,begin:/[$&^_]/},{
className:"meta",begin:/% ?!(T[eE]X|tex|BIB|bib)/,end:"$",relevance:10
},e.COMMENT("%","$",{relevance:0})],i={begin:/\{/,end:/\}/,relevance:0,
contains:["self",...a]},t=e.inherit(i,{relevance:0,endsParent:!0,
contains:[i,...a]}),r={begin:/\[/,end:/\]/,endsParent:!0,relevance:0,
contains:[i,...a]},s={begin:/\s+/,relevance:0},c=[t],l=[r],o=(e,n)=>({
contains:[s],starts:{relevance:0,contains:e,starts:n}}),d=(e,n)=>({
begin:"\\\\"+e+"(?![a-zA-Z@:_])",keywords:{$pattern:/\\[a-zA-Z]+/,keyword:"\\"+e
},relevance:0,contains:[s],starts:n}),g=(n,a)=>e.inherit({
begin:"\\\\begin(?=[ \t]*(\\r?\\n[ \t]*)?\\{"+n+"\\})",keywords:{
$pattern:/\\[a-zA-Z]+/,keyword:"\\begin"},relevance:0
},o(c,a)),m=(n="string")=>e.END_SAME_AS_BEGIN({className:n,begin:/(.|\r?\n)/,
end:/(.|\r?\n)/,excludeBegin:!0,excludeEnd:!0,endsParent:!0}),b=e=>({
className:"string",end:"(?=\\\\end\\{"+e+"\\})"}),p=(e="string")=>({relevance:0,
begin:/\{/,starts:{endsParent:!0,contains:[{className:e,end:/(?=\})/,
endsParent:!0,contains:[{begin:/\{/,end:/\}/,relevance:0,contains:["self"]}]}]}
});return{name:"LaTeX",aliases:["tex"],
contains:[...["verb","lstinline"].map((e=>d(e,{contains:[m()]}))),d("mint",o(c,{
contains:[m()]})),d("mintinline",o(c,{contains:[p(),m()]})),d("url",{
contains:[p("link"),p("link")]}),d("hyperref",{contains:[p("link")]
}),d("href",o(l,{contains:[p("link")]
})),...[].concat(...["","\\*"].map((e=>[g("verbatim"+e,b("verbatim"+e)),g("filecontents"+e,o(c,b("filecontents"+e))),...["","B","L"].map((n=>g(n+"Verbatim"+e,o(l,b(n+"Verbatim"+e)))))]))),g("minted",o(l,o(c,b("minted")))),...a]
}}})();hljs.registerLanguage("latex",e)})();/*! `julia` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{
const r="[A-Za-z_\\u00A1-\\uFFFF][A-Za-z_0-9\\u00A1-\\uFFFF]*",t={$pattern:r,
keyword:["baremodule","begin","break","catch","ccall","const","continue","do","else","elseif","end","export","false","finally","for","function","global","if","import","in","isa","let","local","macro","module","quote","return","true","try","using","where","while"],
literal:["ARGS","C_NULL","DEPOT_PATH","ENDIAN_BOM","ENV","Inf","Inf16","Inf32","Inf64","InsertionSort","LOAD_PATH","MergeSort","NaN","NaN16","NaN32","NaN64","PROGRAM_FILE","QuickSort","RoundDown","RoundFromZero","RoundNearest","RoundNearestTiesAway","RoundNearestTiesUp","RoundToZero","RoundUp","VERSION|0","devnull","false","im","missing","nothing","pi","stderr","stdin","stdout","true","undef","\u03c0","\u212f"],
built_in:["AbstractArray","AbstractChannel","AbstractChar","AbstractDict","AbstractDisplay","AbstractFloat","AbstractIrrational","AbstractMatrix","AbstractRange","AbstractSet","AbstractString","AbstractUnitRange","AbstractVecOrMat","AbstractVector","Any","ArgumentError","Array","AssertionError","BigFloat","BigInt","BitArray","BitMatrix","BitSet","BitVector","Bool","BoundsError","CapturedException","CartesianIndex","CartesianIndices","Cchar","Cdouble","Cfloat","Channel","Char","Cint","Cintmax_t","Clong","Clonglong","Cmd","Colon","Complex","ComplexF16","ComplexF32","ComplexF64","CompositeException","Condition","Cptrdiff_t","Cshort","Csize_t","Cssize_t","Cstring","Cuchar","Cuint","Cuintmax_t","Culong","Culonglong","Cushort","Cvoid","Cwchar_t","Cwstring","DataType","DenseArray","DenseMatrix","DenseVecOrMat","DenseVector","Dict","DimensionMismatch","Dims","DivideError","DomainError","EOFError","Enum","ErrorException","Exception","ExponentialBackOff","Expr","Float16","Float32","Float64","Function","GlobalRef","HTML","IO","IOBuffer","IOContext","IOStream","IdDict","IndexCartesian","IndexLinear","IndexStyle","InexactError","InitError","Int","Int128","Int16","Int32","Int64","Int8","Integer","InterruptException","InvalidStateException","Irrational","KeyError","LinRange","LineNumberNode","LinearIndices","LoadError","MIME","Matrix","Method","MethodError","Missing","MissingException","Module","NTuple","NamedTuple","Nothing","Number","OrdinalRange","OutOfMemoryError","OverflowError","Pair","PartialQuickSort","PermutedDimsArray","Pipe","ProcessFailedException","Ptr","QuoteNode","Rational","RawFD","ReadOnlyMemoryError","Real","ReentrantLock","Ref","Regex","RegexMatch","RoundingMode","SegmentationFault","Set","Signed","Some","StackOverflowError","StepRange","StepRangeLen","StridedArray","StridedMatrix","StridedVecOrMat","StridedVector","String","StringIndexError","SubArray","SubString","SubstitutionString","Symbol","SystemError","Task","TaskFailedException","Text","TextDisplay","Timer","Tuple","Type","TypeError","TypeVar","UInt","UInt128","UInt16","UInt32","UInt64","UInt8","UndefInitializer","UndefKeywordError","UndefRefError","UndefVarError","Union","UnionAll","UnitRange","Unsigned","Val","Vararg","VecElement","VecOrMat","Vector","VersionNumber","WeakKeyDict","WeakRef"]
},n={keywords:t,illegal:/<\//},a={className:"subst",begin:/\$\(/,end:/\)/,
keywords:t},i={className:"variable",begin:"\\$"+r},o={className:"string",
contains:[e.BACKSLASH_ESCAPE,a,i],variants:[{begin:/\w*"""/,end:/"""\w*/,
relevance:10},{begin:/\w*"/,end:/"\w*/}]},s={className:"string",
contains:[e.BACKSLASH_ESCAPE,a,i],begin:"`",end:"`"},l={className:"meta",
begin:"@"+r};return n.name="Julia",n.contains=[{className:"number",
begin:/(\b0x[\d_]*(\.[\d_]*)?|0x\.\d[\d_]*)p[-+]?\d+|\b0[box][a-fA-F0-9][a-fA-F0-9_]*|(\b\d[\d_]*(\.[\d_]*)?|\.\d[\d_]*)([eEfF][-+]?\d+)?/,
relevance:0},{className:"string",begin:/'(.|\\[xXuU][a-zA-Z0-9]+)'/},o,s,l,{
className:"comment",variants:[{begin:"#=",end:"=#",relevance:10},{begin:"#",
end:"$"}]},e.HASH_COMMENT_MODE,{className:"keyword",
begin:"\\b(((abstract|primitive)\\s+)type|(mutable\\s+)?struct)\\b"},{begin:/<:/
}],a.contains=n.contains,n}})();hljs.registerLanguage("julia",e)})();/*! `elixir` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{
const n=e.regex,a="[a-zA-Z_][a-zA-Z0-9_.]*(!|\\?)?",i={$pattern:a,
keyword:["after","alias","and","case","catch","cond","defstruct","defguard","do","else","end","fn","for","if","import","in","not","or","quote","raise","receive","require","reraise","rescue","try","unless","unquote","unquote_splicing","use","when","with|0"],
literal:["false","nil","true"]},s={className:"subst",begin:/#\{/,end:/\}/,
keywords:i},c={match:/\\[\s\S]/,scope:"char.escape",relevance:0},r=[{begin:/"/,
end:/"/},{begin:/'/,end:/'/},{begin:/\//,end:/\//},{begin:/\|/,end:/\|/},{
begin:/\(/,end:/\)/},{begin:/\[/,end:/\]/},{begin:/\{/,end:/\}/},{begin:/</,
end:/>/}],t=e=>({scope:"char.escape",begin:n.concat(/\\/,e),relevance:0}),d={
className:"string",begin:"~[a-z](?=[/|([{<\"'])",
contains:r.map((n=>e.inherit(n,{contains:[t(n.end),c,s]})))},o={
className:"string",begin:"~[A-Z](?=[/|([{<\"'])",
contains:r.map((n=>e.inherit(n,{contains:[t(n.end)]})))},b={className:"regex",
variants:[{begin:"~r(?=[/|([{<\"'])",contains:r.map((a=>e.inherit(a,{
end:n.concat(a.end,/[uismxfU]{0,7}/),contains:[t(a.end),c,s]})))},{
begin:"~R(?=[/|([{<\"'])",contains:r.map((a=>e.inherit(a,{
end:n.concat(a.end,/[uismxfU]{0,7}/),contains:[t(a.end)]})))}]},g={
className:"string",contains:[e.BACKSLASH_ESCAPE,s],variants:[{begin:/"""/,
end:/"""/},{begin:/'''/,end:/'''/},{begin:/~S"""/,end:/"""/,contains:[]},{
begin:/~S"/,end:/"/,contains:[]},{begin:/~S'''/,end:/'''/,contains:[]},{
begin:/~S'/,end:/'/,contains:[]},{begin:/'/,end:/'/},{begin:/"/,end:/"/}]},l={
className:"function",beginKeywords:"def defp defmacro defmacrop",end:/\B\b/,
contains:[e.inherit(e.TITLE_MODE,{begin:a,endsParent:!0})]},m=e.inherit(l,{
className:"class",beginKeywords:"defimpl defmodule defprotocol defrecord",
end:/\bdo\b|$|;/}),u=[g,b,o,d,e.HASH_COMMENT_MODE,m,l,{begin:"::"},{
className:"symbol",begin:":(?![\\s:])",contains:[g,{
begin:"[a-zA-Z_]\\w*[!?=]?|[-+~]@|<<|>>|=~|===?|<=>|[<>]=?|\\*\\*|[-/+%^&*~`|]|\\[\\]=?"
}],relevance:0},{className:"symbol",begin:a+":(?!:)",relevance:0},{
className:"title.class",begin:/(\b[A-Z][a-zA-Z0-9_]+)/,relevance:0},{
className:"number",
begin:"(\\b0o[0-7_]+)|(\\b0b[01_]+)|(\\b0x[0-9a-fA-F_]+)|(-?\\b[0-9][0-9_]*(\\.[0-9_]+([eE][-+]?[0-9]+)?)?)",
relevance:0},{className:"variable",begin:"(\\$\\W)|((\\$|@@?)(\\w+))"}]
;return s.contains=u,{name:"Elixir",aliases:["ex","exs"],keywords:i,contains:u}}
})();hljs.registerLanguage("elixir",e)})();/*! `objectivec` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{const n=/[a-zA-Z@][a-zA-Z0-9_]*/,_={
$pattern:n,keyword:["@interface","@class","@protocol","@implementation"]}
;return{name:"Objective-C",
aliases:["mm","objc","obj-c","obj-c++","objective-c++"],keywords:{
"variable.language":["this","super"],$pattern:n,
keyword:["while","export","sizeof","typedef","const","struct","for","union","volatile","static","mutable","if","do","return","goto","enum","else","break","extern","asm","case","default","register","explicit","typename","switch","continue","inline","readonly","assign","readwrite","self","@synchronized","id","typeof","nonatomic","IBOutlet","IBAction","strong","weak","copy","in","out","inout","bycopy","byref","oneway","__strong","__weak","__block","__autoreleasing","@private","@protected","@public","@try","@property","@end","@throw","@catch","@finally","@autoreleasepool","@synthesize","@dynamic","@selector","@optional","@required","@encode","@package","@import","@defs","@compatibility_alias","__bridge","__bridge_transfer","__bridge_retained","__bridge_retain","__covariant","__contravariant","__kindof","_Nonnull","_Nullable","_Null_unspecified","__FUNCTION__","__PRETTY_FUNCTION__","__attribute__","getter","setter","retain","unsafe_unretained","nonnull","nullable","null_unspecified","null_resettable","class","instancetype","NS_DESIGNATED_INITIALIZER","NS_UNAVAILABLE","NS_REQUIRES_SUPER","NS_RETURNS_INNER_POINTER","NS_INLINE","NS_AVAILABLE","NS_DEPRECATED","NS_ENUM","NS_OPTIONS","NS_SWIFT_UNAVAILABLE","NS_ASSUME_NONNULL_BEGIN","NS_ASSUME_NONNULL_END","NS_REFINED_FOR_SWIFT","NS_SWIFT_NAME","NS_SWIFT_NOTHROW","NS_DURING","NS_HANDLER","NS_ENDHANDLER","NS_VALUERETURN","NS_VOIDRETURN"],
literal:["false","true","FALSE","TRUE","nil","YES","NO","NULL"],
built_in:["dispatch_once_t","dispatch_queue_t","dispatch_sync","dispatch_async","dispatch_once"],
type:["int","float","char","unsigned","signed","short","long","double","wchar_t","unichar","void","bool","BOOL","id|0","_Bool"]
},illegal:"</",contains:[{className:"built_in",
begin:"\\b(AV|CA|CF|CG|CI|CL|CM|CN|CT|MK|MP|MTK|MTL|NS|SCN|SK|UI|WK|XC)\\w+"
},e.C_LINE_COMMENT_MODE,e.C_BLOCK_COMMENT_MODE,e.C_NUMBER_MODE,e.QUOTE_STRING_MODE,e.APOS_STRING_MODE,{
className:"string",variants:[{begin:'@"',end:'"',illegal:"\\n",
contains:[e.BACKSLASH_ESCAPE]}]},{className:"meta",begin:/#\s*[a-z]+\b/,end:/$/,
keywords:{
keyword:"if else elif endif define undef warning error line pragma ifdef ifndef include"
},contains:[{begin:/\\\n/,relevance:0},e.inherit(e.QUOTE_STRING_MODE,{
className:"string"}),{className:"string",begin:/<.*?>/,end:/$/,illegal:"\\n"
},e.C_LINE_COMMENT_MODE,e.C_BLOCK_COMMENT_MODE]},{className:"class",
begin:"("+_.keyword.join("|")+")\\b",end:/(\{|$)/,excludeEnd:!0,keywords:_,
contains:[e.UNDERSCORE_TITLE_MODE]},{begin:"\\."+e.UNDERSCORE_IDENT_RE,
relevance:0}]}}})();hljs.registerLanguage("objectivec",e)})();/*! `javascript` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict"
;const e="[A-Za-z$_][0-9A-Za-z$_]*",n=["as","in","of","if","for","while","finally","var","new","function","do","return","void","else","break","catch","instanceof","with","throw","case","default","try","switch","continue","typeof","delete","let","yield","const","class","debugger","async","await","static","import","from","export","extends"],a=["true","false","null","undefined","NaN","Infinity"],t=["Object","Function","Boolean","Symbol","Math","Date","Number","BigInt","String","RegExp","Array","Float32Array","Float64Array","Int8Array","Uint8Array","Uint8ClampedArray","Int16Array","Int32Array","Uint16Array","Uint32Array","BigInt64Array","BigUint64Array","Set","Map","WeakSet","WeakMap","ArrayBuffer","SharedArrayBuffer","Atomics","DataView","JSON","Promise","Generator","GeneratorFunction","AsyncFunction","Reflect","Proxy","Intl","WebAssembly"],s=["Error","EvalError","InternalError","RangeError","ReferenceError","SyntaxError","TypeError","URIError"],r=["setInterval","setTimeout","clearInterval","clearTimeout","require","exports","eval","isFinite","isNaN","parseFloat","parseInt","decodeURI","decodeURIComponent","encodeURI","encodeURIComponent","escape","unescape"],c=["arguments","this","super","console","window","document","localStorage","module","global"],i=[].concat(r,t,s)
;return o=>{const l=o.regex,b=e,d={begin:/<[A-Za-z0-9\\._:-]+/,
end:/\/[A-Za-z0-9\\._:-]+>|\/>/,isTrulyOpeningTag:(e,n)=>{
const a=e[0].length+e.index,t=e.input[a]
;if("<"===t||","===t)return void n.ignoreMatch();let s
;">"===t&&(((e,{after:n})=>{const a="</"+e[0].slice(1)
;return-1!==e.input.indexOf(a,n)})(e,{after:a
})||n.ignoreMatch()),(s=e.input.substr(a).match(/^\s+extends\s+/))&&0===s.index&&n.ignoreMatch()
}},g={$pattern:e,keyword:n,literal:a,built_in:i,"variable.language":c
},u="\\.([0-9](_?[0-9])*)",m="0|[1-9](_?[0-9])*|0[0-7]*[89][0-9]*",E={
className:"number",variants:[{
begin:`(\\b(${m})((${u})|\\.)?|(${u}))[eE][+-]?([0-9](_?[0-9])*)\\b`},{
begin:`\\b(${m})\\b((${u})\\b|\\.)?|(${u})\\b`},{
begin:"\\b(0|[1-9](_?[0-9])*)n\\b"},{
begin:"\\b0[xX][0-9a-fA-F](_?[0-9a-fA-F])*n?\\b"},{
begin:"\\b0[bB][0-1](_?[0-1])*n?\\b"},{begin:"\\b0[oO][0-7](_?[0-7])*n?\\b"},{
begin:"\\b0[0-7]+n?\\b"}],relevance:0},A={className:"subst",begin:"\\$\\{",
end:"\\}",keywords:g,contains:[]},y={begin:"html`",end:"",starts:{end:"`",
returnEnd:!1,contains:[o.BACKSLASH_ESCAPE,A],subLanguage:"xml"}},N={
begin:"css`",end:"",starts:{end:"`",returnEnd:!1,
contains:[o.BACKSLASH_ESCAPE,A],subLanguage:"css"}},_={className:"string",
begin:"`",end:"`",contains:[o.BACKSLASH_ESCAPE,A]},f={className:"comment",
variants:[o.COMMENT(/\/\*\*(?!\/)/,"\\*/",{relevance:0,contains:[{
begin:"(?=@[A-Za-z]+)",relevance:0,contains:[{className:"doctag",
begin:"@[A-Za-z]+"},{className:"type",begin:"\\{",end:"\\}",excludeEnd:!0,
excludeBegin:!0,relevance:0},{className:"variable",begin:b+"(?=\\s*(-)|$)",
endsParent:!0,relevance:0},{begin:/(?=[^\n])\s/,relevance:0}]}]
}),o.C_BLOCK_COMMENT_MODE,o.C_LINE_COMMENT_MODE]
},h=[o.APOS_STRING_MODE,o.QUOTE_STRING_MODE,y,N,_,E];A.contains=h.concat({
begin:/\{/,end:/\}/,keywords:g,contains:["self"].concat(h)})
;const v=[].concat(f,A.contains),p=v.concat([{begin:/\(/,end:/\)/,keywords:g,
contains:["self"].concat(v)}]),S={className:"params",begin:/\(/,end:/\)/,
excludeBegin:!0,excludeEnd:!0,keywords:g,contains:p},w={variants:[{
match:[/class/,/\s+/,b,/\s+/,/extends/,/\s+/,l.concat(b,"(",l.concat(/\./,b),")*")],
scope:{1:"keyword",3:"title.class",5:"keyword",7:"title.class.inherited"}},{
match:[/class/,/\s+/,b],scope:{1:"keyword",3:"title.class"}}]},R={relevance:0,
match:l.either(/\bJSON/,/\b[A-Z][a-z]+([A-Z][a-z]*|\d)*/,/\b[A-Z]{2,}([A-Z][a-z]+|\d)+([A-Z][a-z]*)*/,/\b[A-Z]{2,}[a-z]+([A-Z][a-z]+|\d)*([A-Z][a-z]*)*/),
className:"title.class",keywords:{_:[...t,...s]}},O={variants:[{
match:[/function/,/\s+/,b,/(?=\s*\()/]},{match:[/function/,/\s*(?=\()/]}],
className:{1:"keyword",3:"title.function"},label:"func.def",contains:[S],
illegal:/%/},k={
match:l.concat(/\b/,(I=[...r,"super"],l.concat("(?!",I.join("|"),")")),b,l.lookahead(/\(/)),
className:"title.function",relevance:0};var I;const x={
begin:l.concat(/\./,l.lookahead(l.concat(b,/(?![0-9A-Za-z$_(])/))),end:b,
excludeBegin:!0,keywords:"prototype",className:"property",relevance:0},T={
match:[/get|set/,/\s+/,b,/(?=\()/],className:{1:"keyword",3:"title.function"},
contains:[{begin:/\(\)/},S]
},C="(\\([^()]*(\\([^()]*(\\([^()]*\\)[^()]*)*\\)[^()]*)*\\)|"+o.UNDERSCORE_IDENT_RE+")\\s*=>",M={
match:[/const|var|let/,/\s+/,b,/\s*/,/=\s*/,/(async\s*)?/,l.lookahead(C)],
keywords:"async",className:{1:"keyword",3:"title.function"},contains:[S]}
;return{name:"Javascript",aliases:["js","jsx","mjs","cjs"],keywords:g,exports:{
PARAMS_CONTAINS:p,CLASS_REFERENCE:R},illegal:/#(?![$_A-z])/,
contains:[o.SHEBANG({label:"shebang",binary:"node",relevance:5}),{
label:"use_strict",className:"meta",relevance:10,
begin:/^\s*['"]use (strict|asm)['"]/
},o.APOS_STRING_MODE,o.QUOTE_STRING_MODE,y,N,_,f,E,R,{className:"attr",
begin:b+l.lookahead(":"),relevance:0},M,{
begin:"("+o.RE_STARTERS_RE+"|\\b(case|return|throw)\\b)\\s*",
keywords:"return throw case",relevance:0,contains:[f,o.REGEXP_MODE,{
className:"function",begin:C,returnBegin:!0,end:"\\s*=>",contains:[{
className:"params",variants:[{begin:o.UNDERSCORE_IDENT_RE,relevance:0},{
className:null,begin:/\(\s*\)/,skip:!0},{begin:/\(/,end:/\)/,excludeBegin:!0,
excludeEnd:!0,keywords:g,contains:p}]}]},{begin:/,/,relevance:0},{match:/\s+/,
relevance:0},{variants:[{begin:"<>",end:"</>"},{
match:/<[A-Za-z0-9\\._:-]+\s*\/>/},{begin:d.begin,
"on:begin":d.isTrulyOpeningTag,end:d.end}],subLanguage:"xml",contains:[{
begin:d.begin,end:d.end,skip:!0,contains:["self"]}]}]},O,{
beginKeywords:"while if switch catch for"},{
begin:"\\b(?!function)"+o.UNDERSCORE_IDENT_RE+"\\([^()]*(\\([^()]*(\\([^()]*\\)[^()]*)*\\)[^()]*)*\\)\\s*\\{",
returnBegin:!0,label:"func.def",contains:[S,o.inherit(o.TITLE_MODE,{begin:b,
className:"title.function"})]},{match:/\.\.\./,relevance:0},x,{match:"\\$"+b,
relevance:0},{match:[/\bconstructor(?=\s*\()/],className:{1:"title.function"},
contains:[S]},k,{relevance:0,match:/\b[A-Z][A-Z_0-9]+\b/,
className:"variable.constant"},w,T,{match:/\$[(.]/}]}}})()
;hljs.registerLanguage("javascript",e)})();/*! `xml` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{
const a=e.regex,n=a.concat(/[A-Z_]/,a.optional(/[A-Z0-9_.-]*:/),/[A-Z0-9_.-]*/),s={
className:"symbol",begin:/&[a-z]+;|&#[0-9]+;|&#x[a-f0-9]+;/},t={begin:/\s/,
contains:[{className:"keyword",begin:/#?[a-z_][a-z1-9_-]+/,illegal:/\n/}]
},i=e.inherit(t,{begin:/\(/,end:/\)/}),c=e.inherit(e.APOS_STRING_MODE,{
className:"string"}),l=e.inherit(e.QUOTE_STRING_MODE,{className:"string"}),r={
endsWithParent:!0,illegal:/</,relevance:0,contains:[{className:"attr",
begin:/[A-Za-z0-9._:-]+/,relevance:0},{begin:/=\s*/,relevance:0,contains:[{
className:"string",endsParent:!0,variants:[{begin:/"/,end:/"/,contains:[s]},{
begin:/'/,end:/'/,contains:[s]},{begin:/[^\s"'=<>`]+/}]}]}]};return{
name:"HTML, XML",
aliases:["html","xhtml","rss","atom","xjb","xsd","xsl","plist","wsf","svg"],
case_insensitive:!0,contains:[{className:"meta",begin:/<![a-z]/,end:/>/,
relevance:10,contains:[t,l,c,i,{begin:/\[/,end:/\]/,contains:[{className:"meta",
begin:/<![a-z]/,end:/>/,contains:[t,i,l,c]}]}]},e.COMMENT(/<!--/,/-->/,{
relevance:10}),{begin:/<!\[CDATA\[/,end:/\]\]>/,relevance:10},s,{
className:"meta",end:/\?>/,variants:[{begin:/<\?xml/,relevance:10,contains:[l]
},{begin:/<\?[a-z][a-z0-9]+/}]},{className:"tag",begin:/<style(?=\s|>)/,end:/>/,
keywords:{name:"style"},contains:[r],starts:{end:/<\/style>/,returnEnd:!0,
subLanguage:["css","xml"]}},{className:"tag",begin:/<script(?=\s|>)/,end:/>/,
keywords:{name:"script"},contains:[r],starts:{end:/<\/script>/,returnEnd:!0,
subLanguage:["javascript","handlebars","xml"]}},{className:"tag",begin:/<>|<\/>/
},{className:"tag",
begin:a.concat(/</,a.lookahead(a.concat(n,a.either(/\/>/,/>/,/\s/)))),
end:/\/?>/,contains:[{className:"name",begin:n,relevance:0,starts:r}]},{
className:"tag",begin:a.concat(/<\//,a.lookahead(a.concat(n,/>/))),contains:[{
className:"name",begin:n,relevance:0},{begin:/>/,relevance:0,endsParent:!0}]}]}}
})();hljs.registerLanguage("xml",e)})();/*! `markdown` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{const n={begin:/<\/?[A-Za-z_]/,
end:">",subLanguage:"xml",relevance:0},a={variants:[{begin:/\[.+?\]\[.*?\]/,
relevance:0},{
begin:/\[.+?\]\(((data|javascript|mailto):|(?:http|ftp)s?:\/\/).*?\)/,
relevance:2},{
begin:e.regex.concat(/\[.+?\]\(/,/[A-Za-z][A-Za-z0-9+.-]*/,/:\/\/.*?\)/),
relevance:2},{begin:/\[.+?\]\([./?&#].*?\)/,relevance:1},{
begin:/\[.*?\]\(.*?\)/,relevance:0}],returnBegin:!0,contains:[{match:/\[(?=\])/
},{className:"string",relevance:0,begin:"\\[",end:"\\]",excludeBegin:!0,
returnEnd:!0},{className:"link",relevance:0,begin:"\\]\\(",end:"\\)",
excludeBegin:!0,excludeEnd:!0},{className:"symbol",relevance:0,begin:"\\]\\[",
end:"\\]",excludeBegin:!0,excludeEnd:!0}]},i={className:"strong",contains:[],
variants:[{begin:/_{2}/,end:/_{2}/},{begin:/\*{2}/,end:/\*{2}/}]},s={
className:"emphasis",contains:[],variants:[{begin:/\*(?!\*)/,end:/\*/},{
begin:/_(?!_)/,end:/_/,relevance:0}]},c=e.inherit(i,{contains:[]
}),t=e.inherit(s,{contains:[]});i.contains.push(t),s.contains.push(c)
;let g=[n,a];return[i,s,c,t].forEach((e=>{e.contains=e.contains.concat(g)
})),g=g.concat(i,s),{name:"Markdown",aliases:["md","mkdown","mkd"],contains:[{
className:"section",variants:[{begin:"^#{1,6}",end:"$",contains:g},{
begin:"(?=^.+?\\n[=-]{2,}$)",contains:[{begin:"^[=-]*$"},{begin:"^",end:"\\n",
contains:g}]}]},n,{className:"bullet",begin:"^[ \t]*([*+-]|(\\d+\\.))(?=\\s+)",
end:"\\s+",excludeEnd:!0},i,s,{className:"quote",begin:"^>\\s+",contains:g,
end:"$"},{className:"code",variants:[{begin:"(`{3,})[^`](.|\\n)*?\\1`*[ ]*"},{
begin:"(~{3,})[^~](.|\\n)*?\\1~*[ ]*"},{begin:"```",end:"```+[ ]*$"},{
begin:"~~~",end:"~~~+[ ]*$"},{begin:"`.+?`"},{begin:"(?=^( {4}|\\t))",
contains:[{begin:"^( {4}|\\t)",end:"(\\n)$"}],relevance:0}]},{
begin:"^[-\\*]{3,}",end:"$"},a,{begin:/^\[[^\n]+\]:/,returnBegin:!0,contains:[{
className:"symbol",begin:/\[/,end:/\]/,excludeBegin:!0,excludeEnd:!0},{
className:"link",begin:/:\s*/,end:/$/,excludeBegin:!0}]}]}}})()
;hljs.registerLanguage("markdown",e)})();/*! `rust` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{const t=e.regex,n={
className:"title.function.invoke",relevance:0,
begin:t.concat(/\b/,/(?!let\b)/,e.IDENT_RE,t.lookahead(/\s*\(/))
},a="([ui](8|16|32|64|128|size)|f(32|64))?",i=["drop ","Copy","Send","Sized","Sync","Drop","Fn","FnMut","FnOnce","ToOwned","Clone","Debug","PartialEq","PartialOrd","Eq","Ord","AsRef","AsMut","Into","From","Default","Iterator","Extend","IntoIterator","DoubleEndedIterator","ExactSizeIterator","SliceConcatExt","ToString","assert!","assert_eq!","bitflags!","bytes!","cfg!","col!","concat!","concat_idents!","debug_assert!","debug_assert_eq!","env!","panic!","file!","format!","format_args!","include_bin!","include_str!","line!","local_data_key!","module_path!","option_env!","print!","println!","select!","stringify!","try!","unimplemented!","unreachable!","vec!","write!","writeln!","macro_rules!","assert_ne!","debug_assert_ne!"]
;return{name:"Rust",aliases:["rs"],keywords:{$pattern:e.IDENT_RE+"!?",
type:["i8","i16","i32","i64","i128","isize","u8","u16","u32","u64","u128","usize","f32","f64","str","char","bool","Box","Option","Result","String","Vec"],
keyword:["abstract","as","async","await","become","box","break","const","continue","crate","do","dyn","else","enum","extern","false","final","fn","for","if","impl","in","let","loop","macro","match","mod","move","mut","override","priv","pub","ref","return","self","Self","static","struct","super","trait","true","try","type","typeof","unsafe","unsized","use","virtual","where","while","yield"],
literal:["true","false","Some","None","Ok","Err"],built_in:i},illegal:"</",
contains:[e.C_LINE_COMMENT_MODE,e.COMMENT("/\\*","\\*/",{contains:["self"]
}),e.inherit(e.QUOTE_STRING_MODE,{begin:/b?"/,illegal:null}),{
className:"string",variants:[{begin:/b?r(#*)"(.|\n)*?"\1(?!#)/},{
begin:/b?'\\?(x\w{2}|u\w{4}|U\w{8}|.)'/}]},{className:"symbol",
begin:/'[a-zA-Z_][a-zA-Z0-9_]*/},{className:"number",variants:[{
begin:"\\b0b([01_]+)"+a},{begin:"\\b0o([0-7_]+)"+a},{
begin:"\\b0x([A-Fa-f0-9_]+)"+a},{
begin:"\\b(\\d[\\d_]*(\\.[0-9_]+)?([eE][+-]?[0-9_]+)?)"+a}],relevance:0},{
begin:[/fn/,/\s+/,e.UNDERSCORE_IDENT_RE],className:{1:"keyword",
3:"title.function"}},{className:"meta",begin:"#!?\\[",end:"\\]",contains:[{
className:"string",begin:/"/,end:/"/}]},{
begin:[/let/,/\s+/,/(?:mut\s+)?/,e.UNDERSCORE_IDENT_RE],className:{1:"keyword",
3:"keyword",4:"variable"}},{
begin:[/for/,/\s+/,e.UNDERSCORE_IDENT_RE,/\s+/,/in/],className:{1:"keyword",
3:"variable",5:"keyword"}},{begin:[/type/,/\s+/,e.UNDERSCORE_IDENT_RE],
className:{1:"keyword",3:"title.class"}},{
begin:[/(?:trait|enum|struct|union|impl|for)/,/\s+/,e.UNDERSCORE_IDENT_RE],
className:{1:"keyword",3:"title.class"}},{begin:e.IDENT_RE+"::",keywords:{
keyword:"Self",built_in:i}},{className:"punctuation",begin:"->"},n]}}})()
;hljs.registerLanguage("rust",e)})();/*! `bash` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{const s=e.regex,t={},n={begin:/\$\{/,
end:/\}/,contains:["self",{begin:/:-/,contains:[t]}]};Object.assign(t,{
className:"variable",variants:[{
begin:s.concat(/\$[\w\d#@][\w\d_]*/,"(?![\\w\\d])(?![$])")},n]});const a={
className:"subst",begin:/\$\(/,end:/\)/,contains:[e.BACKSLASH_ESCAPE]},i={
begin:/<<-?\s*(?=\w+)/,starts:{contains:[e.END_SAME_AS_BEGIN({begin:/(\w+)/,
end:/(\w+)/,className:"string"})]}},c={className:"string",begin:/"/,end:/"/,
contains:[e.BACKSLASH_ESCAPE,t,a]};a.contains.push(c);const o={begin:/\$\(\(/,
end:/\)\)/,contains:[{begin:/\d+#[0-9a-f]+/,className:"number"},e.NUMBER_MODE,t]
},r=e.SHEBANG({binary:"(fish|bash|zsh|sh|csh|ksh|tcsh|dash|scsh)",relevance:10
}),l={className:"function",begin:/\w[\w\d_]*\s*\(\s*\)\s*\{/,returnBegin:!0,
contains:[e.inherit(e.TITLE_MODE,{begin:/\w[\w\d_]*/})],relevance:0};return{
name:"Bash",aliases:["sh"],keywords:{$pattern:/\b[a-z][a-z0-9._-]+\b/,
keyword:["if","then","else","elif","fi","for","while","in","do","done","case","esac","function"],
literal:["true","false"],
built_in:["break","cd","continue","eval","exec","exit","export","getopts","hash","pwd","readonly","return","shift","test","times","trap","umask","unset","alias","bind","builtin","caller","command","declare","echo","enable","help","let","local","logout","mapfile","printf","read","readarray","source","type","typeset","ulimit","unalias","set","shopt","autoload","bg","bindkey","bye","cap","chdir","clone","comparguments","compcall","compctl","compdescribe","compfiles","compgroups","compquote","comptags","comptry","compvalues","dirs","disable","disown","echotc","echoti","emulate","fc","fg","float","functions","getcap","getln","history","integer","jobs","kill","limit","log","noglob","popd","print","pushd","pushln","rehash","sched","setcap","setopt","stat","suspend","ttyctl","unfunction","unhash","unlimit","unsetopt","vared","wait","whence","where","which","zcompile","zformat","zftp","zle","zmodload","zparseopts","zprof","zpty","zregexparse","zsocket","zstyle","ztcp","chcon","chgrp","chown","chmod","cp","dd","df","dir","dircolors","ln","ls","mkdir","mkfifo","mknod","mktemp","mv","realpath","rm","rmdir","shred","sync","touch","truncate","vdir","b2sum","base32","base64","cat","cksum","comm","csplit","cut","expand","fmt","fold","head","join","md5sum","nl","numfmt","od","paste","ptx","pr","sha1sum","sha224sum","sha256sum","sha384sum","sha512sum","shuf","sort","split","sum","tac","tail","tr","tsort","unexpand","uniq","wc","arch","basename","chroot","date","dirname","du","echo","env","expr","factor","groups","hostid","id","link","logname","nice","nohup","nproc","pathchk","pinky","printenv","printf","pwd","readlink","runcon","seq","sleep","stat","stdbuf","stty","tee","test","timeout","tty","uname","unlink","uptime","users","who","whoami","yes"]
},contains:[r,e.SHEBANG(),l,o,e.HASH_COMMENT_MODE,i,{match:/(\/[a-z._-]+)+/},c,{
className:"",begin:/\\"/},{className:"string",begin:/'/,end:/'/},t]}}})()
;hljs.registerLanguage("bash",e)})();/*! `shell` grammar compiled for Highlight.js 11.5.1 */
(()=>{var s=(()=>{"use strict";return s=>({name:"Shell Session",
aliases:["console","shellsession"],contains:[{className:"meta.prompt",
begin:/^\s{0,3}[/~\w\d[\]()@-]*[>%$#][ ]?/,starts:{end:/[^\\](?=\s*$)/,
subLanguage:"bash"}}]})})();hljs.registerLanguage("shell",s)})();/*! `ruby` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{
const n=e.regex,a="([a-zA-Z_]\\w*[!?=]?|[-+~]@|<<|>>|=~|===?|<=>|[<>]=?|\\*\\*|[-/+%^&*~`|]|\\[\\]=?)",s=n.either(/\b([A-Z]+[a-z0-9]+)+/,/\b([A-Z]+[a-z0-9]+)+[A-Z]+/),i=n.concat(s,/(::\w+)*/),r={
"variable.constant":["__FILE__","__LINE__"],
"variable.language":["self","super"],
keyword:["alias","and","attr_accessor","attr_reader","attr_writer","begin","BEGIN","break","case","class","defined","do","else","elsif","end","END","ensure","for","if","in","include","module","next","not","or","redo","require","rescue","retry","return","then","undef","unless","until","when","while","yield"],
built_in:["proc","lambda"],literal:["true","false","nil"]},c={
className:"doctag",begin:"@[A-Za-z]+"},t={begin:"#<",end:">"
},b=[e.COMMENT("#","$",{contains:[c]}),e.COMMENT("^=begin","^=end",{
contains:[c],relevance:10}),e.COMMENT("^__END__",e.MATCH_NOTHING_RE)],l={
className:"subst",begin:/#\{/,end:/\}/,keywords:r},d={className:"string",
contains:[e.BACKSLASH_ESCAPE,l],variants:[{begin:/'/,end:/'/},{begin:/"/,end:/"/
},{begin:/`/,end:/`/},{begin:/%[qQwWx]?\(/,end:/\)/},{begin:/%[qQwWx]?\[/,
end:/\]/},{begin:/%[qQwWx]?\{/,end:/\}/},{begin:/%[qQwWx]?</,end:/>/},{
begin:/%[qQwWx]?\//,end:/\//},{begin:/%[qQwWx]?%/,end:/%/},{begin:/%[qQwWx]?-/,
end:/-/},{begin:/%[qQwWx]?\|/,end:/\|/},{begin:/\B\?(\\\d{1,3})/},{
begin:/\B\?(\\x[A-Fa-f0-9]{1,2})/},{begin:/\B\?(\\u\{?[A-Fa-f0-9]{1,6}\}?)/},{
begin:/\B\?(\\M-\\C-|\\M-\\c|\\c\\M-|\\M-|\\C-\\M-)[\x20-\x7e]/},{
begin:/\B\?\\(c|C-)[\x20-\x7e]/},{begin:/\B\?\\?\S/},{
begin:n.concat(/<<[-~]?'?/,n.lookahead(/(\w+)(?=\W)[^\n]*\n(?:[^\n]*\n)*?\s*\1\b/)),
contains:[e.END_SAME_AS_BEGIN({begin:/(\w+)/,end:/(\w+)/,
contains:[e.BACKSLASH_ESCAPE,l]})]}]},g="[0-9](_?[0-9])*",o={className:"number",
relevance:0,variants:[{
begin:`\\b([1-9](_?[0-9])*|0)(\\.(${g}))?([eE][+-]?(${g})|r)?i?\\b`},{
begin:"\\b0[dD][0-9](_?[0-9])*r?i?\\b"},{begin:"\\b0[bB][0-1](_?[0-1])*r?i?\\b"
},{begin:"\\b0[oO][0-7](_?[0-7])*r?i?\\b"},{
begin:"\\b0[xX][0-9a-fA-F](_?[0-9a-fA-F])*r?i?\\b"},{
begin:"\\b0(_?[0-7])+r?i?\\b"}]},_={variants:[{match:/\(\)/},{
className:"params",begin:/\(/,end:/(?=\))/,excludeBegin:!0,endsParent:!0,
keywords:r}]},u=[d,{variants:[{match:[/class\s+/,i,/\s+<\s+/,i]},{
match:[/class\s+/,i]}],scope:{2:"title.class",4:"title.class.inherited"},
keywords:r},{relevance:0,match:[i,/\.new[ (]/],scope:{1:"title.class"}},{
relevance:0,match:/\b[A-Z][A-Z_0-9]+\b/,className:"variable.constant"},{
match:[/def/,/\s+/,a],scope:{1:"keyword",3:"title.function"},contains:[_]},{
begin:e.IDENT_RE+"::"},{className:"symbol",
begin:e.UNDERSCORE_IDENT_RE+"(!|\\?)?:",relevance:0},{className:"symbol",
begin:":(?!\\s)",contains:[d,{begin:a}],relevance:0},o,{className:"variable",
begin:"(\\$\\W)|((\\$|@@?)(\\w+))(?=[^@$?])(?![A-Za-z])(?![@$?'])"},{
className:"params",begin:/\|/,end:/\|/,excludeBegin:!0,excludeEnd:!0,
relevance:0,keywords:r},{begin:"("+e.RE_STARTERS_RE+"|unless)\\s*",
keywords:"unless",contains:[{className:"regexp",contains:[e.BACKSLASH_ESCAPE,l],
illegal:/\n/,variants:[{begin:"/",end:"/[a-z]*"},{begin:/%r\{/,end:/\}[a-z]*/},{
begin:"%r\\(",end:"\\)[a-z]*"},{begin:"%r!",end:"![a-z]*"},{begin:"%r\\[",
end:"\\][a-z]*"}]}].concat(t,b),relevance:0}].concat(t,b)
;l.contains=u,_.contains=u;const w=[{begin:/^\s*=>/,starts:{end:"$",contains:u}
},{className:"meta.prompt",
begin:"^([>?]>|[\\w#]+\\(\\w+\\):\\d+:\\d+[>*]|(\\w+-)?\\d+\\.\\d+\\.\\d+(p\\d+)?[^\\d][^>]+>)(?=[ ])",
starts:{end:"$",keywords:r,contains:u}}];return b.unshift(t),{name:"Ruby",
aliases:["rb","gemspec","podspec","thor","irb"],keywords:r,illegal:/\/\*/,
contains:[e.SHEBANG({binary:"ruby"})].concat(w).concat(b).concat(u)}}})()
;hljs.registerLanguage("ruby",e)})();/*! `yaml` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{
const n="true false yes no null",a="[\\w#;/?:@&=+$,.~*'()[\\]]+",s={
className:"string",relevance:0,variants:[{begin:/'/,end:/'/},{begin:/"/,end:/"/
},{begin:/\S+/}],contains:[e.BACKSLASH_ESCAPE,{className:"template-variable",
variants:[{begin:/\{\{/,end:/\}\}/},{begin:/%\{/,end:/\}/}]}]},i=e.inherit(s,{
variants:[{begin:/'/,end:/'/},{begin:/"/,end:/"/},{begin:/[^\s,{}[\]]+/}]}),l={
end:",",endsWithParent:!0,excludeEnd:!0,keywords:n,relevance:0},t={begin:/\{/,
end:/\}/,contains:[l],illegal:"\\n",relevance:0},g={begin:"\\[",end:"\\]",
contains:[l],illegal:"\\n",relevance:0},b=[{className:"attr",variants:[{
begin:"\\w[\\w :\\/.-]*:(?=[ \t]|$)"},{begin:'"\\w[\\w :\\/.-]*":(?=[ \t]|$)'},{
begin:"'\\w[\\w :\\/.-]*':(?=[ \t]|$)"}]},{className:"meta",begin:"^---\\s*$",
relevance:10},{className:"string",
begin:"[\\|>]([1-9]?[+-])?[ ]*\\n( +)[^ ][^\\n]*\\n(\\2[^\\n]+\\n?)*"},{
begin:"<%[%=-]?",end:"[%-]?%>",subLanguage:"ruby",excludeBegin:!0,excludeEnd:!0,
relevance:0},{className:"type",begin:"!\\w+!"+a},{className:"type",
begin:"!<"+a+">"},{className:"type",begin:"!"+a},{className:"type",begin:"!!"+a
},{className:"meta",begin:"&"+e.UNDERSCORE_IDENT_RE+"$"},{className:"meta",
begin:"\\*"+e.UNDERSCORE_IDENT_RE+"$"},{className:"bullet",begin:"-(?=[ ]|$)",
relevance:0},e.HASH_COMMENT_MODE,{beginKeywords:n,keywords:{literal:n}},{
className:"number",
begin:"\\b[0-9]{4}(-[0-9][0-9]){0,2}([Tt \\t][0-9][0-9]?(:[0-9][0-9]){2})?(\\.[0-9]*)?([ \\t])*(Z|[-+][0-9][0-9]?(:[0-9][0-9])?)?\\b"
},{className:"number",begin:e.C_NUMBER_RE+"\\b",relevance:0},t,g,s],r=[...b]
;return r.pop(),r.push(i),l.contains=r,{name:"YAML",case_insensitive:!0,
aliases:["yml"],contains:b}}})();hljs.registerLanguage("yaml",e)})();/*! `elm` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{const n={
variants:[e.COMMENT("--","$"),e.COMMENT(/\{-/,/-\}/,{contains:["self"]})]},i={
className:"type",begin:"\\b[A-Z][\\w']*",relevance:0},s={begin:"\\(",end:"\\)",
illegal:'"',contains:[{className:"type",
begin:"\\b[A-Z][\\w]*(\\((\\.\\.|,|\\w+)\\))?"},n]};return{name:"Elm",
keywords:["let","in","if","then","else","case","of","where","module","import","exposing","type","alias","as","infix","infixl","infixr","port","effect","command","subscription"],
contains:[{beginKeywords:"port effect module",end:"exposing",
keywords:"port effect module where command subscription exposing",
contains:[s,n],illegal:"\\W\\.|;"},{begin:"import",end:"$",
keywords:"import as exposing",contains:[s,n],illegal:"\\W\\.|;"},{begin:"type",
end:"$",keywords:"type alias",contains:[i,s,{begin:/\{/,end:/\}/,
contains:s.contains},n]},{beginKeywords:"infix infixl infixr",end:"$",
contains:[e.C_NUMBER_MODE,n]},{begin:"port",end:"$",keywords:"port",contains:[n]
},{className:"string",begin:"'\\\\?.",end:"'",illegal:"."
},e.QUOTE_STRING_MODE,e.C_NUMBER_MODE,i,e.inherit(e.TITLE_MODE,{
begin:"^[_a-z][\\w']*"}),n,{begin:"->|<-"}],illegal:/;/}}})()
;hljs.registerLanguage("elm",e)})();/*! `wasm` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{e.regex;const a=e.COMMENT(/\(;/,/;\)/)
;return a.contains.push("self"),{name:"WebAssembly",keywords:{$pattern:/[\w.]+/,
keyword:["anyfunc","block","br","br_if","br_table","call","call_indirect","data","drop","elem","else","end","export","func","global.get","global.set","local.get","local.set","local.tee","get_global","get_local","global","if","import","local","loop","memory","memory.grow","memory.size","module","mut","nop","offset","param","result","return","select","set_global","set_local","start","table","tee_local","then","type","unreachable"]
},contains:[e.COMMENT(/;;/,/$/),a,{match:[/(?:offset|align)/,/\s*/,/=/],
className:{1:"keyword",3:"operator"}},{className:"variable",begin:/\$[\w_]+/},{
match:/(\((?!;)|\))+/,className:"punctuation",relevance:0},{
begin:[/(?:func|call|call_indirect)/,/\s+/,/\$[^\s)]+/],className:{1:"keyword",
3:"title.function"}},e.QUOTE_STRING_MODE,{match:/(i32|i64|f32|f64)(?!\.)/,
className:"type"},{className:"keyword",
match:/\b(f32|f64|i32|i64)(?:\.(?:abs|add|and|ceil|clz|const|convert_[su]\/i(?:32|64)|copysign|ctz|demote\/f64|div(?:_[su])?|eqz?|extend_[su]\/i32|floor|ge(?:_[su])?|gt(?:_[su])?|le(?:_[su])?|load(?:(?:8|16|32)_[su])?|lt(?:_[su])?|max|min|mul|nearest|neg?|or|popcnt|promote\/f32|reinterpret\/[fi](?:32|64)|rem_[su]|rot[lr]|shl|shr_[su]|store(?:8|16|32)?|sqrt|sub|trunc(?:_[su]\/f(?:32|64))?|wrap\/i64|xor))\b/
},{className:"number",relevance:0,
match:/[+-]?\b(?:\d(?:_?\d)*(?:\.\d(?:_?\d)*)?(?:[eE][+-]?\d(?:_?\d)*)?|0x[\da-fA-F](?:_?[\da-fA-F])*(?:\.[\da-fA-F](?:_?[\da-fA-D])*)?(?:[pP][+-]?\d(?:_?\d)*)?)\b|\binf\b|\bnan(?::0x[\da-fA-F](?:_?[\da-fA-D])*)?\b/
}]}}})();hljs.registerLanguage("wasm",e)})();/*! `awk` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>({name:"Awk",keywords:{
keyword:"BEGIN END if else while do for in break continue delete next nextfile function func exit|10"
},contains:[{className:"variable",variants:[{begin:/\$[\w\d#@][\w\d_]*/},{
begin:/\$\{(.*?)\}/}]},{className:"string",contains:[e.BACKSLASH_ESCAPE],
variants:[{begin:/(u|b)?r?'''/,end:/'''/,relevance:10},{begin:/(u|b)?r?"""/,
end:/"""/,relevance:10},{begin:/(u|r|ur)'/,end:/'/,relevance:10},{
begin:/(u|r|ur)"/,end:/"/,relevance:10},{begin:/(b|br)'/,end:/'/},{
begin:/(b|br)"/,end:/"/},e.APOS_STRING_MODE,e.QUOTE_STRING_MODE]
},e.REGEXP_MODE,e.HASH_COMMENT_MODE,e.NUMBER_MODE]})})()
;hljs.registerLanguage("awk",e)})();/*! `css` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict"
;const e=["a","abbr","address","article","aside","audio","b","blockquote","body","button","canvas","caption","cite","code","dd","del","details","dfn","div","dl","dt","em","fieldset","figcaption","figure","footer","form","h1","h2","h3","h4","h5","h6","header","hgroup","html","i","iframe","img","input","ins","kbd","label","legend","li","main","mark","menu","nav","object","ol","p","q","quote","samp","section","span","strong","summary","sup","table","tbody","td","textarea","tfoot","th","thead","time","tr","ul","var","video"],i=["any-hover","any-pointer","aspect-ratio","color","color-gamut","color-index","device-aspect-ratio","device-height","device-width","display-mode","forced-colors","grid","height","hover","inverted-colors","monochrome","orientation","overflow-block","overflow-inline","pointer","prefers-color-scheme","prefers-contrast","prefers-reduced-motion","prefers-reduced-transparency","resolution","scan","scripting","update","width","min-width","max-width","min-height","max-height"],r=["active","any-link","blank","checked","current","default","defined","dir","disabled","drop","empty","enabled","first","first-child","first-of-type","fullscreen","future","focus","focus-visible","focus-within","has","host","host-context","hover","indeterminate","in-range","invalid","is","lang","last-child","last-of-type","left","link","local-link","not","nth-child","nth-col","nth-last-child","nth-last-col","nth-last-of-type","nth-of-type","only-child","only-of-type","optional","out-of-range","past","placeholder-shown","read-only","read-write","required","right","root","scope","target","target-within","user-invalid","valid","visited","where"],t=["after","backdrop","before","cue","cue-region","first-letter","first-line","grammar-error","marker","part","placeholder","selection","slotted","spelling-error"],o=["align-content","align-items","align-self","all","animation","animation-delay","animation-direction","animation-duration","animation-fill-mode","animation-iteration-count","animation-name","animation-play-state","animation-timing-function","backface-visibility","background","background-attachment","background-blend-mode","background-clip","background-color","background-image","background-origin","background-position","background-repeat","background-size","block-size","border","border-block","border-block-color","border-block-end","border-block-end-color","border-block-end-style","border-block-end-width","border-block-start","border-block-start-color","border-block-start-style","border-block-start-width","border-block-style","border-block-width","border-bottom","border-bottom-color","border-bottom-left-radius","border-bottom-right-radius","border-bottom-style","border-bottom-width","border-collapse","border-color","border-image","border-image-outset","border-image-repeat","border-image-slice","border-image-source","border-image-width","border-inline","border-inline-color","border-inline-end","border-inline-end-color","border-inline-end-style","border-inline-end-width","border-inline-start","border-inline-start-color","border-inline-start-style","border-inline-start-width","border-inline-style","border-inline-width","border-left","border-left-color","border-left-style","border-left-width","border-radius","border-right","border-right-color","border-right-style","border-right-width","border-spacing","border-style","border-top","border-top-color","border-top-left-radius","border-top-right-radius","border-top-style","border-top-width","border-width","bottom","box-decoration-break","box-shadow","box-sizing","break-after","break-before","break-inside","caption-side","caret-color","clear","clip","clip-path","clip-rule","color","column-count","column-fill","column-gap","column-rule","column-rule-color","column-rule-style","column-rule-width","column-span","column-width","columns","contain","content","content-visibility","counter-increment","counter-reset","cue","cue-after","cue-before","cursor","direction","display","empty-cells","filter","flex","flex-basis","flex-direction","flex-flow","flex-grow","flex-shrink","flex-wrap","float","flow","font","font-display","font-family","font-feature-settings","font-kerning","font-language-override","font-size","font-size-adjust","font-smoothing","font-stretch","font-style","font-synthesis","font-variant","font-variant-caps","font-variant-east-asian","font-variant-ligatures","font-variant-numeric","font-variant-position","font-variation-settings","font-weight","gap","glyph-orientation-vertical","grid","grid-area","grid-auto-columns","grid-auto-flow","grid-auto-rows","grid-column","grid-column-end","grid-column-start","grid-gap","grid-row","grid-row-end","grid-row-start","grid-template","grid-template-areas","grid-template-columns","grid-template-rows","hanging-punctuation","height","hyphens","icon","image-orientation","image-rendering","image-resolution","ime-mode","inline-size","isolation","justify-content","left","letter-spacing","line-break","line-height","list-style","list-style-image","list-style-position","list-style-type","margin","margin-block","margin-block-end","margin-block-start","margin-bottom","margin-inline","margin-inline-end","margin-inline-start","margin-left","margin-right","margin-top","marks","mask","mask-border","mask-border-mode","mask-border-outset","mask-border-repeat","mask-border-slice","mask-border-source","mask-border-width","mask-clip","mask-composite","mask-image","mask-mode","mask-origin","mask-position","mask-repeat","mask-size","mask-type","max-block-size","max-height","max-inline-size","max-width","min-block-size","min-height","min-inline-size","min-width","mix-blend-mode","nav-down","nav-index","nav-left","nav-right","nav-up","none","normal","object-fit","object-position","opacity","order","orphans","outline","outline-color","outline-offset","outline-style","outline-width","overflow","overflow-wrap","overflow-x","overflow-y","padding","padding-block","padding-block-end","padding-block-start","padding-bottom","padding-inline","padding-inline-end","padding-inline-start","padding-left","padding-right","padding-top","page-break-after","page-break-before","page-break-inside","pause","pause-after","pause-before","perspective","perspective-origin","pointer-events","position","quotes","resize","rest","rest-after","rest-before","right","row-gap","scroll-margin","scroll-margin-block","scroll-margin-block-end","scroll-margin-block-start","scroll-margin-bottom","scroll-margin-inline","scroll-margin-inline-end","scroll-margin-inline-start","scroll-margin-left","scroll-margin-right","scroll-margin-top","scroll-padding","scroll-padding-block","scroll-padding-block-end","scroll-padding-block-start","scroll-padding-bottom","scroll-padding-inline","scroll-padding-inline-end","scroll-padding-inline-start","scroll-padding-left","scroll-padding-right","scroll-padding-top","scroll-snap-align","scroll-snap-stop","scroll-snap-type","scrollbar-color","scrollbar-gutter","scrollbar-width","shape-image-threshold","shape-margin","shape-outside","speak","speak-as","src","tab-size","table-layout","text-align","text-align-all","text-align-last","text-combine-upright","text-decoration","text-decoration-color","text-decoration-line","text-decoration-style","text-emphasis","text-emphasis-color","text-emphasis-position","text-emphasis-style","text-indent","text-justify","text-orientation","text-overflow","text-rendering","text-shadow","text-transform","text-underline-position","top","transform","transform-box","transform-origin","transform-style","transition","transition-delay","transition-duration","transition-property","transition-timing-function","unicode-bidi","vertical-align","visibility","voice-balance","voice-duration","voice-family","voice-pitch","voice-range","voice-rate","voice-stress","voice-volume","white-space","widows","width","will-change","word-break","word-spacing","word-wrap","writing-mode","z-index"].reverse()
;return n=>{const a=n.regex,l=(e=>({IMPORTANT:{scope:"meta",begin:"!important"},
BLOCK_COMMENT:e.C_BLOCK_COMMENT_MODE,HEXCOLOR:{scope:"number",
begin:/#(([0-9a-fA-F]{3,4})|(([0-9a-fA-F]{2}){3,4}))\b/},FUNCTION_DISPATCH:{
className:"built_in",begin:/[\w-]+(?=\()/},ATTRIBUTE_SELECTOR_MODE:{
scope:"selector-attr",begin:/\[/,end:/\]/,illegal:"$",
contains:[e.APOS_STRING_MODE,e.QUOTE_STRING_MODE]},CSS_NUMBER_MODE:{
scope:"number",
begin:e.NUMBER_RE+"(%|em|ex|ch|rem|vw|vh|vmin|vmax|cm|mm|in|pt|pc|px|deg|grad|rad|turn|s|ms|Hz|kHz|dpi|dpcm|dppx)?",
relevance:0},CSS_VARIABLE:{className:"attr",begin:/--[A-Za-z][A-Za-z0-9_-]*/}
}))(n),s=[n.APOS_STRING_MODE,n.QUOTE_STRING_MODE];return{name:"CSS",
case_insensitive:!0,illegal:/[=|'\$]/,keywords:{keyframePosition:"from to"},
classNameAliases:{keyframePosition:"selector-tag"},contains:[l.BLOCK_COMMENT,{
begin:/-(webkit|moz|ms|o)-(?=[a-z])/},l.CSS_NUMBER_MODE,{
className:"selector-id",begin:/#[A-Za-z0-9_-]+/,relevance:0},{
className:"selector-class",begin:"\\.[a-zA-Z-][a-zA-Z0-9_-]*",relevance:0
},l.ATTRIBUTE_SELECTOR_MODE,{className:"selector-pseudo",variants:[{
begin:":("+r.join("|")+")"},{begin:":(:)?("+t.join("|")+")"}]},l.CSS_VARIABLE,{
className:"attribute",begin:"\\b("+o.join("|")+")\\b"},{begin:/:/,end:/[;}{]/,
contains:[l.BLOCK_COMMENT,l.HEXCOLOR,l.IMPORTANT,l.CSS_NUMBER_MODE,...s,{
begin:/(url|data-uri)\(/,end:/\)/,relevance:0,keywords:{built_in:"url data-uri"
},contains:[{className:"string",begin:/[^)]/,endsWithParent:!0,excludeEnd:!0}]
},l.FUNCTION_DISPATCH]},{begin:a.lookahead(/@/),end:"[{;]",relevance:0,
illegal:/:/,contains:[{className:"keyword",begin:/@-?\w[\w]*(-\w+)*/},{
begin:/\s/,endsWithParent:!0,excludeEnd:!0,relevance:0,keywords:{
$pattern:/[a-z-]+/,keyword:"and or not only",attribute:i.join(" ")},contains:[{
begin:/[a-z-]+(?=:)/,className:"attribute"},...s,l.CSS_NUMBER_MODE]}]},{
className:"selector-tag",begin:"\\b("+e.join("|")+")\\b"}]}}})()
;hljs.registerLanguage("css",e)})();/*! `lua` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{const t="\\[=*\\[",a="\\]=*\\]",n={
begin:t,end:a,contains:["self"]
},o=[e.COMMENT("--(?!\\[=*\\[)","$"),e.COMMENT("--\\[=*\\[",a,{contains:[n],
relevance:10})];return{name:"Lua",keywords:{$pattern:e.UNDERSCORE_IDENT_RE,
literal:"true false nil",
keyword:"and break do else elseif end for goto if in local not or repeat return then until while",
built_in:"_G _ENV _VERSION __index __newindex __mode __call __metatable __tostring __len __gc __add __sub __mul __div __mod __pow __concat __unm __eq __lt __le assert collectgarbage dofile error getfenv getmetatable ipairs load loadfile loadstring module next pairs pcall print rawequal rawget rawset require select setfenv setmetatable tonumber tostring type unpack xpcall arg self coroutine resume yield status wrap create running debug getupvalue debug sethook getmetatable gethook setmetatable setlocal traceback setfenv getinfo setupvalue getlocal getregistry getfenv io lines write close flush open output type read stderr stdin input stdout popen tmpfile math log max acos huge ldexp pi cos tanh pow deg tan cosh sinh random randomseed frexp ceil floor rad abs sqrt modf asin min mod fmod log10 atan2 exp sin atan os exit setlocale date getenv difftime remove time clock tmpname rename execute package preload loadlib loaded loaders cpath config path seeall string sub upper len gfind rep find match char dump gmatch reverse byte format gsub lower table setn insert getn foreachi maxn foreach concat sort remove"
},contains:o.concat([{className:"function",beginKeywords:"function",end:"\\)",
contains:[e.inherit(e.TITLE_MODE,{
begin:"([_a-zA-Z]\\w*\\.)*([_a-zA-Z]\\w*:)?[_a-zA-Z]\\w*"}),{className:"params",
begin:"\\(",endsWithParent:!0,contains:o}].concat(o)
},e.C_NUMBER_MODE,e.APOS_STRING_MODE,e.QUOTE_STRING_MODE,{className:"string",
begin:t,end:a,contains:[n],relevance:5}])}}})();hljs.registerLanguage("lua",e)
})();/*! `typescript` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict"
;const e="[A-Za-z$_][0-9A-Za-z$_]*",n=["as","in","of","if","for","while","finally","var","new","function","do","return","void","else","break","catch","instanceof","with","throw","case","default","try","switch","continue","typeof","delete","let","yield","const","class","debugger","async","await","static","import","from","export","extends"],a=["true","false","null","undefined","NaN","Infinity"],t=["Object","Function","Boolean","Symbol","Math","Date","Number","BigInt","String","RegExp","Array","Float32Array","Float64Array","Int8Array","Uint8Array","Uint8ClampedArray","Int16Array","Int32Array","Uint16Array","Uint32Array","BigInt64Array","BigUint64Array","Set","Map","WeakSet","WeakMap","ArrayBuffer","SharedArrayBuffer","Atomics","DataView","JSON","Promise","Generator","GeneratorFunction","AsyncFunction","Reflect","Proxy","Intl","WebAssembly"],s=["Error","EvalError","InternalError","RangeError","ReferenceError","SyntaxError","TypeError","URIError"],r=["setInterval","setTimeout","clearInterval","clearTimeout","require","exports","eval","isFinite","isNaN","parseFloat","parseInt","decodeURI","decodeURIComponent","encodeURI","encodeURIComponent","escape","unescape"],c=["arguments","this","super","console","window","document","localStorage","module","global"],i=[].concat(r,t,s)
;function o(o){const l=o.regex,d=e,b={begin:/<[A-Za-z0-9\\._:-]+/,
end:/\/[A-Za-z0-9\\._:-]+>|\/>/,isTrulyOpeningTag:(e,n)=>{
const a=e[0].length+e.index,t=e.input[a]
;if("<"===t||","===t)return void n.ignoreMatch();let s
;">"===t&&(((e,{after:n})=>{const a="</"+e[0].slice(1)
;return-1!==e.input.indexOf(a,n)})(e,{after:a
})||n.ignoreMatch()),(s=e.input.substr(a).match(/^\s+extends\s+/))&&0===s.index&&n.ignoreMatch()
}},g={$pattern:e,keyword:n,literal:a,built_in:i,"variable.language":c
},u="\\.([0-9](_?[0-9])*)",m="0|[1-9](_?[0-9])*|0[0-7]*[89][0-9]*",E={
className:"number",variants:[{
begin:`(\\b(${m})((${u})|\\.)?|(${u}))[eE][+-]?([0-9](_?[0-9])*)\\b`},{
begin:`\\b(${m})\\b((${u})\\b|\\.)?|(${u})\\b`},{
begin:"\\b(0|[1-9](_?[0-9])*)n\\b"},{
begin:"\\b0[xX][0-9a-fA-F](_?[0-9a-fA-F])*n?\\b"},{
begin:"\\b0[bB][0-1](_?[0-1])*n?\\b"},{begin:"\\b0[oO][0-7](_?[0-7])*n?\\b"},{
begin:"\\b0[0-7]+n?\\b"}],relevance:0},y={className:"subst",begin:"\\$\\{",
end:"\\}",keywords:g,contains:[]},A={begin:"html`",end:"",starts:{end:"`",
returnEnd:!1,contains:[o.BACKSLASH_ESCAPE,y],subLanguage:"xml"}},_={
begin:"css`",end:"",starts:{end:"`",returnEnd:!1,
contains:[o.BACKSLASH_ESCAPE,y],subLanguage:"css"}},p={className:"string",
begin:"`",end:"`",contains:[o.BACKSLASH_ESCAPE,y]},N={className:"comment",
variants:[o.COMMENT(/\/\*\*(?!\/)/,"\\*/",{relevance:0,contains:[{
begin:"(?=@[A-Za-z]+)",relevance:0,contains:[{className:"doctag",
begin:"@[A-Za-z]+"},{className:"type",begin:"\\{",end:"\\}",excludeEnd:!0,
excludeBegin:!0,relevance:0},{className:"variable",begin:d+"(?=\\s*(-)|$)",
endsParent:!0,relevance:0},{begin:/(?=[^\n])\s/,relevance:0}]}]
}),o.C_BLOCK_COMMENT_MODE,o.C_LINE_COMMENT_MODE]
},f=[o.APOS_STRING_MODE,o.QUOTE_STRING_MODE,A,_,p,E];y.contains=f.concat({
begin:/\{/,end:/\}/,keywords:g,contains:["self"].concat(f)})
;const h=[].concat(N,y.contains),v=h.concat([{begin:/\(/,end:/\)/,keywords:g,
contains:["self"].concat(h)}]),S={className:"params",begin:/\(/,end:/\)/,
excludeBegin:!0,excludeEnd:!0,keywords:g,contains:v},w={variants:[{
match:[/class/,/\s+/,d,/\s+/,/extends/,/\s+/,l.concat(d,"(",l.concat(/\./,d),")*")],
scope:{1:"keyword",3:"title.class",5:"keyword",7:"title.class.inherited"}},{
match:[/class/,/\s+/,d],scope:{1:"keyword",3:"title.class"}}]},R={relevance:0,
match:l.either(/\bJSON/,/\b[A-Z][a-z]+([A-Z][a-z]*|\d)*/,/\b[A-Z]{2,}([A-Z][a-z]+|\d)+([A-Z][a-z]*)*/,/\b[A-Z]{2,}[a-z]+([A-Z][a-z]+|\d)*([A-Z][a-z]*)*/),
className:"title.class",keywords:{_:[...t,...s]}},x={variants:[{
match:[/function/,/\s+/,d,/(?=\s*\()/]},{match:[/function/,/\s*(?=\()/]}],
className:{1:"keyword",3:"title.function"},label:"func.def",contains:[S],
illegal:/%/},k={
match:l.concat(/\b/,(O=[...r,"super"],l.concat("(?!",O.join("|"),")")),d,l.lookahead(/\(/)),
className:"title.function",relevance:0};var O;const I={
begin:l.concat(/\./,l.lookahead(l.concat(d,/(?![0-9A-Za-z$_(])/))),end:d,
excludeBegin:!0,keywords:"prototype",className:"property",relevance:0},C={
match:[/get|set/,/\s+/,d,/(?=\()/],className:{1:"keyword",3:"title.function"},
contains:[{begin:/\(\)/},S]
},T="(\\([^()]*(\\([^()]*(\\([^()]*\\)[^()]*)*\\)[^()]*)*\\)|"+o.UNDERSCORE_IDENT_RE+")\\s*=>",M={
match:[/const|var|let/,/\s+/,d,/\s*/,/=\s*/,/(async\s*)?/,l.lookahead(T)],
keywords:"async",className:{1:"keyword",3:"title.function"},contains:[S]}
;return{name:"Javascript",aliases:["js","jsx","mjs","cjs"],keywords:g,exports:{
PARAMS_CONTAINS:v,CLASS_REFERENCE:R},illegal:/#(?![$_A-z])/,
contains:[o.SHEBANG({label:"shebang",binary:"node",relevance:5}),{
label:"use_strict",className:"meta",relevance:10,
begin:/^\s*['"]use (strict|asm)['"]/
},o.APOS_STRING_MODE,o.QUOTE_STRING_MODE,A,_,p,N,E,R,{className:"attr",
begin:d+l.lookahead(":"),relevance:0},M,{
begin:"("+o.RE_STARTERS_RE+"|\\b(case|return|throw)\\b)\\s*",
keywords:"return throw case",relevance:0,contains:[N,o.REGEXP_MODE,{
className:"function",begin:T,returnBegin:!0,end:"\\s*=>",contains:[{
className:"params",variants:[{begin:o.UNDERSCORE_IDENT_RE,relevance:0},{
className:null,begin:/\(\s*\)/,skip:!0},{begin:/\(/,end:/\)/,excludeBegin:!0,
excludeEnd:!0,keywords:g,contains:v}]}]},{begin:/,/,relevance:0},{match:/\s+/,
relevance:0},{variants:[{begin:"<>",end:"</>"},{
match:/<[A-Za-z0-9\\._:-]+\s*\/>/},{begin:b.begin,
"on:begin":b.isTrulyOpeningTag,end:b.end}],subLanguage:"xml",contains:[{
begin:b.begin,end:b.end,skip:!0,contains:["self"]}]}]},x,{
beginKeywords:"while if switch catch for"},{
begin:"\\b(?!function)"+o.UNDERSCORE_IDENT_RE+"\\([^()]*(\\([^()]*(\\([^()]*\\)[^()]*)*\\)[^()]*)*\\)\\s*\\{",
returnBegin:!0,label:"func.def",contains:[S,o.inherit(o.TITLE_MODE,{begin:d,
className:"title.function"})]},{match:/\.\.\./,relevance:0},I,{match:"\\$"+d,
relevance:0},{match:[/\bconstructor(?=\s*\()/],className:{1:"title.function"},
contains:[S]},k,{relevance:0,match:/\b[A-Z][A-Z_0-9]+\b/,
className:"variable.constant"},w,C,{match:/\$[(.]/}]}}return t=>{
const s=o(t),r=["any","void","number","boolean","string","object","never","symbol","bigint","unknown"],l={
beginKeywords:"namespace",end:/\{/,excludeEnd:!0,
contains:[s.exports.CLASS_REFERENCE]},d={beginKeywords:"interface",end:/\{/,
excludeEnd:!0,keywords:{keyword:"interface extends",built_in:r},
contains:[s.exports.CLASS_REFERENCE]},b={$pattern:e,
keyword:n.concat(["type","namespace","interface","public","private","protected","implements","declare","abstract","readonly","enum","override"]),
literal:a,built_in:i.concat(r),"variable.language":c},g={className:"meta",
begin:"@[A-Za-z$_][0-9A-Za-z$_]*"},u=(e,n,a)=>{
const t=e.contains.findIndex((e=>e.label===n))
;if(-1===t)throw Error("can not find mode to replace");e.contains.splice(t,1,a)}
;return Object.assign(s.keywords,b),
s.exports.PARAMS_CONTAINS.push(g),s.contains=s.contains.concat([g,l,d]),
u(s,"shebang",t.SHEBANG()),u(s,"use_strict",{className:"meta",relevance:10,
begin:/^\s*['"]use strict['"]/
}),s.contains.find((e=>"func.def"===e.label)).relevance=0,Object.assign(s,{
name:"TypeScript",aliases:["ts","tsx"]}),s}})()
;hljs.registerLanguage("typescript",e)})();/*! `php` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{
const t=e.regex,a=/(?![A-Za-z0-9])(?![$])/,r=t.concat(/[a-zA-Z_\x7f-\xff][a-zA-Z0-9_\x7f-\xff]*/,a),n=t.concat(/(\\?[A-Z][a-z0-9_\x7f-\xff]+|\\?[A-Z]+(?=[A-Z][a-z0-9_\x7f-\xff])){1,}/,a),o={
scope:"variable",match:"\\$+"+r},c={scope:"subst",variants:[{begin:/\$\w+/},{
begin:/\{\$/,end:/\}/}]},i=e.inherit(e.APOS_STRING_MODE,{illegal:null
}),s="[ \t\n]",l={scope:"string",variants:[e.inherit(e.QUOTE_STRING_MODE,{
illegal:null,contains:e.QUOTE_STRING_MODE.contains.concat(c)
}),i,e.END_SAME_AS_BEGIN({begin:/<<<[ \t]*(\w+)\n/,end:/[ \t]*(\w+)\b/,
contains:e.QUOTE_STRING_MODE.contains.concat(c)})]},_={scope:"number",
variants:[{begin:"\\b0[bB][01]+(?:_[01]+)*\\b"},{
begin:"\\b0[oO][0-7]+(?:_[0-7]+)*\\b"},{
begin:"\\b0[xX][\\da-fA-F]+(?:_[\\da-fA-F]+)*\\b"},{
begin:"(?:\\b\\d+(?:_\\d+)*(\\.(?:\\d+(?:_\\d+)*))?|\\B\\.\\d+)(?:[eE][+-]?\\d+)?"
}],relevance:0
},d=["false","null","true"],p=["__CLASS__","__DIR__","__FILE__","__FUNCTION__","__COMPILER_HALT_OFFSET__","__LINE__","__METHOD__","__NAMESPACE__","__TRAIT__","die","echo","exit","include","include_once","print","require","require_once","array","abstract","and","as","binary","bool","boolean","break","callable","case","catch","class","clone","const","continue","declare","default","do","double","else","elseif","empty","enddeclare","endfor","endforeach","endif","endswitch","endwhile","enum","eval","extends","final","finally","float","for","foreach","from","global","goto","if","implements","instanceof","insteadof","int","integer","interface","isset","iterable","list","match|0","mixed","new","never","object","or","private","protected","public","readonly","real","return","string","switch","throw","trait","try","unset","use","var","void","while","xor","yield"],b=["Error|0","AppendIterator","ArgumentCountError","ArithmeticError","ArrayIterator","ArrayObject","AssertionError","BadFunctionCallException","BadMethodCallException","CachingIterator","CallbackFilterIterator","CompileError","Countable","DirectoryIterator","DivisionByZeroError","DomainException","EmptyIterator","ErrorException","Exception","FilesystemIterator","FilterIterator","GlobIterator","InfiniteIterator","InvalidArgumentException","IteratorIterator","LengthException","LimitIterator","LogicException","MultipleIterator","NoRewindIterator","OutOfBoundsException","OutOfRangeException","OuterIterator","OverflowException","ParentIterator","ParseError","RangeException","RecursiveArrayIterator","RecursiveCachingIterator","RecursiveCallbackFilterIterator","RecursiveDirectoryIterator","RecursiveFilterIterator","RecursiveIterator","RecursiveIteratorIterator","RecursiveRegexIterator","RecursiveTreeIterator","RegexIterator","RuntimeException","SeekableIterator","SplDoublyLinkedList","SplFileInfo","SplFileObject","SplFixedArray","SplHeap","SplMaxHeap","SplMinHeap","SplObjectStorage","SplObserver","SplPriorityQueue","SplQueue","SplStack","SplSubject","SplTempFileObject","TypeError","UnderflowException","UnexpectedValueException","UnhandledMatchError","ArrayAccess","BackedEnum","Closure","Fiber","Generator","Iterator","IteratorAggregate","Serializable","Stringable","Throwable","Traversable","UnitEnum","WeakReference","WeakMap","Directory","__PHP_Incomplete_Class","parent","php_user_filter","self","static","stdClass"],E={
keyword:p,literal:(e=>{const t=[];return e.forEach((e=>{
t.push(e),e.toLowerCase()===e?t.push(e.toUpperCase()):t.push(e.toLowerCase())
})),t})(d),built_in:b},u=e=>e.map((e=>e.replace(/\|\d+$/,""))),g={variants:[{
match:[/new/,t.concat(s,"+"),t.concat("(?!",u(b).join("\\b|"),"\\b)"),n],scope:{
1:"keyword",4:"title.class"}}]},h=t.concat(r,"\\b(?!\\()"),m={variants:[{
match:[t.concat(/::/,t.lookahead(/(?!class\b)/)),h],scope:{2:"variable.constant"
}},{match:[/::/,/class/],scope:{2:"variable.language"}},{
match:[n,t.concat(/::/,t.lookahead(/(?!class\b)/)),h],scope:{1:"title.class",
3:"variable.constant"}},{match:[n,t.concat("::",t.lookahead(/(?!class\b)/))],
scope:{1:"title.class"}},{match:[n,/::/,/class/],scope:{1:"title.class",
3:"variable.language"}}]},I={scope:"attr",
match:t.concat(r,t.lookahead(":"),t.lookahead(/(?!::)/))},f={relevance:0,
begin:/\(/,end:/\)/,keywords:E,contains:[I,o,m,e.C_BLOCK_COMMENT_MODE,l,_,g]
},O={relevance:0,
match:[/\b/,t.concat("(?!fn\\b|function\\b|",u(p).join("\\b|"),"|",u(b).join("\\b|"),"\\b)"),r,t.concat(s,"*"),t.lookahead(/(?=\()/)],
scope:{3:"title.function.invoke"},contains:[f]};f.contains.push(O)
;const v=[I,m,e.C_BLOCK_COMMENT_MODE,l,_,g];return{case_insensitive:!1,
keywords:E,contains:[{begin:t.concat(/#\[\s*/,n),beginScope:"meta",end:/]/,
endScope:"meta",keywords:{literal:d,keyword:["new","array"]},contains:[{
begin:/\[/,end:/]/,keywords:{literal:d,keyword:["new","array"]},
contains:["self",...v]},...v,{scope:"meta",match:n}]
},e.HASH_COMMENT_MODE,e.COMMENT("//","$"),e.COMMENT("/\\*","\\*/",{contains:[{
scope:"doctag",match:"@[A-Za-z]+"}]}),{match:/__halt_compiler\(\);/,
keywords:"__halt_compiler",starts:{scope:"comment",end:e.MATCH_NOTHING_RE,
contains:[{match:/\?>/,scope:"meta",endsParent:!0}]}},{scope:"meta",variants:[{
begin:/<\?php/,relevance:10},{begin:/<\?=/},{begin:/<\?/,relevance:.1},{
begin:/\?>/}]},{scope:"variable.language",match:/\$this\b/},o,O,m,{
match:[/const/,/\s/,r],scope:{1:"keyword",3:"variable.constant"}},g,{
scope:"function",relevance:0,beginKeywords:"fn function",end:/[;{]/,
excludeEnd:!0,illegal:"[$%\\[]",contains:[{beginKeywords:"use"
},e.UNDERSCORE_TITLE_MODE,{begin:"=>",endsParent:!0},{scope:"params",
begin:"\\(",end:"\\)",excludeBegin:!0,excludeEnd:!0,keywords:E,
contains:["self",o,m,e.C_BLOCK_COMMENT_MODE,l,_]}]},{scope:"class",variants:[{
beginKeywords:"enum",illegal:/[($"]/},{beginKeywords:"class interface trait",
illegal:/[:($"]/}],relevance:0,end:/\{/,excludeEnd:!0,contains:[{
beginKeywords:"extends implements"},e.UNDERSCORE_TITLE_MODE]},{
beginKeywords:"namespace",relevance:0,end:";",illegal:/[.']/,
contains:[e.inherit(e.UNDERSCORE_TITLE_MODE,{scope:"title.class"})]},{
beginKeywords:"use",relevance:0,end:";",contains:[{
match:/\b(as|const|function)\b/,scope:"keyword"},e.UNDERSCORE_TITLE_MODE]},l,_]}
}})();hljs.registerLanguage("php",e)})();/*! `scala` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{const n=e.regex,a={className:"subst",
variants:[{begin:"\\$[A-Za-z0-9_]+"},{begin:/\$\{/,end:/\}/}]},s={
className:"string",variants:[{begin:'"""',end:'"""'},{begin:'"',end:'"',
illegal:"\\n",contains:[e.BACKSLASH_ESCAPE]},{begin:'[a-z]+"',end:'"',
illegal:"\\n",contains:[e.BACKSLASH_ESCAPE,a]},{className:"string",
begin:'[a-z]+"""',end:'"""',contains:[a],relevance:10}]},i={className:"type",
begin:"\\b[A-Z][A-Za-z0-9_]*",relevance:0},t={className:"title",
begin:/[^0-9\n\t "'(),.`{}\[\]:;][^\n\t "'(),.`{}\[\]:;]+|[^0-9\n\t "'(),.`{}\[\]:;=]/,
relevance:0},l={className:"class",beginKeywords:"class object trait type",
end:/[:={\[\n;]/,excludeEnd:!0,
contains:[e.C_LINE_COMMENT_MODE,e.C_BLOCK_COMMENT_MODE,{
beginKeywords:"extends with",relevance:10},{begin:/\[/,end:/\]/,excludeBegin:!0,
excludeEnd:!0,relevance:0,contains:[i]},{className:"params",begin:/\(/,end:/\)/,
excludeBegin:!0,excludeEnd:!0,relevance:0,contains:[i]},t]},c={
className:"function",beginKeywords:"def",end:n.lookahead(/[:={\[(\n;]/),
contains:[t]};return{name:"Scala",keywords:{literal:"true false null",
keyword:"type yield lazy override def with val var sealed abstract private trait object if then forSome for while do throw finally protected extends import final return else break new catch super class case package default try this match continue throws implicit export enum given"
},
contains:[e.C_LINE_COMMENT_MODE,e.C_BLOCK_COMMENT_MODE,s,i,c,l,e.C_NUMBER_MODE,{
begin:[/^\s*/,"extension",/\s+(?=[[(])/],beginScope:{2:"keyword"}},[{
begin:[/^\s*/,/end/,/\s+/,/(extension\b)?/],beginScope:{2:"keyword",4:"keyword"}
}],{match:/\.inline\b/},{begin:/\binline(?=\s)/,keywords:"inline"},{
begin:[/\(\s*/,/using/,/\s+(?!\))/],beginScope:{2:"keyword"}},{className:"meta",
begin:"@[A-Za-z]+"}]}}})();hljs.registerLanguage("scala",e)})();/*! `excel` grammar compiled for Highlight.js 11.5.1 */
(()=>{var E=(()=>{"use strict";return E=>({name:"Excel formulae",
aliases:["xlsx","xls"],case_insensitive:!0,keywords:{$pattern:/[a-zA-Z][\w\.]*/,
built_in:["ABS","ACCRINT","ACCRINTM","ACOS","ACOSH","ACOT","ACOTH","AGGREGATE","ADDRESS","AMORDEGRC","AMORLINC","AND","ARABIC","AREAS","ASC","ASIN","ASINH","ATAN","ATAN2","ATANH","AVEDEV","AVERAGE","AVERAGEA","AVERAGEIF","AVERAGEIFS","BAHTTEXT","BASE","BESSELI","BESSELJ","BESSELK","BESSELY","BETADIST","BETA.DIST","BETAINV","BETA.INV","BIN2DEC","BIN2HEX","BIN2OCT","BINOMDIST","BINOM.DIST","BINOM.DIST.RANGE","BINOM.INV","BITAND","BITLSHIFT","BITOR","BITRSHIFT","BITXOR","CALL","CEILING","CEILING.MATH","CEILING.PRECISE","CELL","CHAR","CHIDIST","CHIINV","CHITEST","CHISQ.DIST","CHISQ.DIST.RT","CHISQ.INV","CHISQ.INV.RT","CHISQ.TEST","CHOOSE","CLEAN","CODE","COLUMN","COLUMNS","COMBIN","COMBINA","COMPLEX","CONCAT","CONCATENATE","CONFIDENCE","CONFIDENCE.NORM","CONFIDENCE.T","CONVERT","CORREL","COS","COSH","COT","COTH","COUNT","COUNTA","COUNTBLANK","COUNTIF","COUNTIFS","COUPDAYBS","COUPDAYS","COUPDAYSNC","COUPNCD","COUPNUM","COUPPCD","COVAR","COVARIANCE.P","COVARIANCE.S","CRITBINOM","CSC","CSCH","CUBEKPIMEMBER","CUBEMEMBER","CUBEMEMBERPROPERTY","CUBERANKEDMEMBER","CUBESET","CUBESETCOUNT","CUBEVALUE","CUMIPMT","CUMPRINC","DATE","DATEDIF","DATEVALUE","DAVERAGE","DAY","DAYS","DAYS360","DB","DBCS","DCOUNT","DCOUNTA","DDB","DEC2BIN","DEC2HEX","DEC2OCT","DECIMAL","DEGREES","DELTA","DEVSQ","DGET","DISC","DMAX","DMIN","DOLLAR","DOLLARDE","DOLLARFR","DPRODUCT","DSTDEV","DSTDEVP","DSUM","DURATION","DVAR","DVARP","EDATE","EFFECT","ENCODEURL","EOMONTH","ERF","ERF.PRECISE","ERFC","ERFC.PRECISE","ERROR.TYPE","EUROCONVERT","EVEN","EXACT","EXP","EXPON.DIST","EXPONDIST","FACT","FACTDOUBLE","FALSE|0","F.DIST","FDIST","F.DIST.RT","FILTERXML","FIND","FINDB","F.INV","F.INV.RT","FINV","FISHER","FISHERINV","FIXED","FLOOR","FLOOR.MATH","FLOOR.PRECISE","FORECAST","FORECAST.ETS","FORECAST.ETS.CONFINT","FORECAST.ETS.SEASONALITY","FORECAST.ETS.STAT","FORECAST.LINEAR","FORMULATEXT","FREQUENCY","F.TEST","FTEST","FV","FVSCHEDULE","GAMMA","GAMMA.DIST","GAMMADIST","GAMMA.INV","GAMMAINV","GAMMALN","GAMMALN.PRECISE","GAUSS","GCD","GEOMEAN","GESTEP","GETPIVOTDATA","GROWTH","HARMEAN","HEX2BIN","HEX2DEC","HEX2OCT","HLOOKUP","HOUR","HYPERLINK","HYPGEOM.DIST","HYPGEOMDIST","IF","IFERROR","IFNA","IFS","IMABS","IMAGINARY","IMARGUMENT","IMCONJUGATE","IMCOS","IMCOSH","IMCOT","IMCSC","IMCSCH","IMDIV","IMEXP","IMLN","IMLOG10","IMLOG2","IMPOWER","IMPRODUCT","IMREAL","IMSEC","IMSECH","IMSIN","IMSINH","IMSQRT","IMSUB","IMSUM","IMTAN","INDEX","INDIRECT","INFO","INT","INTERCEPT","INTRATE","IPMT","IRR","ISBLANK","ISERR","ISERROR","ISEVEN","ISFORMULA","ISLOGICAL","ISNA","ISNONTEXT","ISNUMBER","ISODD","ISREF","ISTEXT","ISO.CEILING","ISOWEEKNUM","ISPMT","JIS","KURT","LARGE","LCM","LEFT","LEFTB","LEN","LENB","LINEST","LN","LOG","LOG10","LOGEST","LOGINV","LOGNORM.DIST","LOGNORMDIST","LOGNORM.INV","LOOKUP","LOWER","MATCH","MAX","MAXA","MAXIFS","MDETERM","MDURATION","MEDIAN","MID","MIDBs","MIN","MINIFS","MINA","MINUTE","MINVERSE","MIRR","MMULT","MOD","MODE","MODE.MULT","MODE.SNGL","MONTH","MROUND","MULTINOMIAL","MUNIT","N","NA","NEGBINOM.DIST","NEGBINOMDIST","NETWORKDAYS","NETWORKDAYS.INTL","NOMINAL","NORM.DIST","NORMDIST","NORMINV","NORM.INV","NORM.S.DIST","NORMSDIST","NORM.S.INV","NORMSINV","NOT","NOW","NPER","NPV","NUMBERVALUE","OCT2BIN","OCT2DEC","OCT2HEX","ODD","ODDFPRICE","ODDFYIELD","ODDLPRICE","ODDLYIELD","OFFSET","OR","PDURATION","PEARSON","PERCENTILE.EXC","PERCENTILE.INC","PERCENTILE","PERCENTRANK.EXC","PERCENTRANK.INC","PERCENTRANK","PERMUT","PERMUTATIONA","PHI","PHONETIC","PI","PMT","POISSON.DIST","POISSON","POWER","PPMT","PRICE","PRICEDISC","PRICEMAT","PROB","PRODUCT","PROPER","PV","QUARTILE","QUARTILE.EXC","QUARTILE.INC","QUOTIENT","RADIANS","RAND","RANDBETWEEN","RANK.AVG","RANK.EQ","RANK","RATE","RECEIVED","REGISTER.ID","REPLACE","REPLACEB","REPT","RIGHT","RIGHTB","ROMAN","ROUND","ROUNDDOWN","ROUNDUP","ROW","ROWS","RRI","RSQ","RTD","SEARCH","SEARCHB","SEC","SECH","SECOND","SERIESSUM","SHEET","SHEETS","SIGN","SIN","SINH","SKEW","SKEW.P","SLN","SLOPE","SMALL","SQL.REQUEST","SQRT","SQRTPI","STANDARDIZE","STDEV","STDEV.P","STDEV.S","STDEVA","STDEVP","STDEVPA","STEYX","SUBSTITUTE","SUBTOTAL","SUM","SUMIF","SUMIFS","SUMPRODUCT","SUMSQ","SUMX2MY2","SUMX2PY2","SUMXMY2","SWITCH","SYD","T","TAN","TANH","TBILLEQ","TBILLPRICE","TBILLYIELD","T.DIST","T.DIST.2T","T.DIST.RT","TDIST","TEXT","TEXTJOIN","TIME","TIMEVALUE","T.INV","T.INV.2T","TINV","TODAY","TRANSPOSE","TREND","TRIM","TRIMMEAN","TRUE|0","TRUNC","T.TEST","TTEST","TYPE","UNICHAR","UNICODE","UPPER","VALUE","VAR","VAR.P","VAR.S","VARA","VARP","VARPA","VDB","VLOOKUP","WEBSERVICE","WEEKDAY","WEEKNUM","WEIBULL","WEIBULL.DIST","WORKDAY","WORKDAY.INTL","XIRR","XNPV","XOR","YEAR","YEARFRAC","YIELD","YIELDDISC","YIELDMAT","Z.TEST","ZTEST"]
},contains:[{begin:/^=/,end:/[^=]/,returnEnd:!0,illegal:/=/,relevance:10},{
className:"symbol",begin:/\b[A-Z]{1,2}\d+\b/,end:/[^\d]/,excludeEnd:!0,
relevance:0},{className:"symbol",begin:/[A-Z]{0,2}\d*:[A-Z]{0,2}\d*/,relevance:0
},E.BACKSLASH_ESCAPE,E.QUOTE_STRING_MODE,{className:"number",
begin:E.NUMBER_RE+"(%)?",relevance:0},E.COMMENT(/\bN\(/,/\)/,{excludeBegin:!0,
excludeEnd:!0,illegal:/\n/})]})})();hljs.registerLanguage("excel",E)})();/*! `c` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{const n=e.regex,t=e.COMMENT("//","$",{
contains:[{begin:/\\\n/}]
}),s="[a-zA-Z_]\\w*::",a="(decltype\\(auto\\)|"+n.optional(s)+"[a-zA-Z_]\\w*"+n.optional("<[^<>]+>")+")",r={
className:"type",variants:[{begin:"\\b[a-z\\d_]*_t\\b"},{
match:/\batomic_[a-z]{3,6}\b/}]},i={className:"string",variants:[{
begin:'(u8?|U|L)?"',end:'"',illegal:"\\n",contains:[e.BACKSLASH_ESCAPE]},{
begin:"(u8?|U|L)?'(\\\\(x[0-9A-Fa-f]{2}|u[0-9A-Fa-f]{4,8}|[0-7]{3}|\\S)|.)",
end:"'",illegal:"."},e.END_SAME_AS_BEGIN({
begin:/(?:u8?|U|L)?R"([^()\\ ]{0,16})\(/,end:/\)([^()\\ ]{0,16})"/})]},l={
className:"number",variants:[{begin:"\\b(0b[01']+)"},{
begin:"(-?)\\b([\\d']+(\\.[\\d']*)?|\\.[\\d']+)((ll|LL|l|L)(u|U)?|(u|U)(ll|LL|l|L)?|f|F|b|B)"
},{
begin:"(-?)(\\b0[xX][a-fA-F0-9']+|(\\b[\\d']+(\\.[\\d']*)?|\\.[\\d']+)([eE][-+]?[\\d']+)?)"
}],relevance:0},o={className:"meta",begin:/#\s*[a-z]+\b/,end:/$/,keywords:{
keyword:"if else elif endif define undef warning error line pragma _Pragma ifdef ifndef include"
},contains:[{begin:/\\\n/,relevance:0},e.inherit(i,{className:"string"}),{
className:"string",begin:/<.*?>/},t,e.C_BLOCK_COMMENT_MODE]},c={
className:"title",begin:n.optional(s)+e.IDENT_RE,relevance:0
},d=n.optional(s)+e.IDENT_RE+"\\s*\\(",u={
keyword:["asm","auto","break","case","continue","default","do","else","enum","extern","for","fortran","goto","if","inline","register","restrict","return","sizeof","struct","switch","typedef","union","volatile","while","_Alignas","_Alignof","_Atomic","_Generic","_Noreturn","_Static_assert","_Thread_local","alignas","alignof","noreturn","static_assert","thread_local","_Pragma"],
type:["float","double","signed","unsigned","int","short","long","char","void","_Bool","_Complex","_Imaginary","_Decimal32","_Decimal64","_Decimal128","const","static","complex","bool","imaginary"],
literal:"true false NULL",
built_in:"std string wstring cin cout cerr clog stdin stdout stderr stringstream istringstream ostringstream auto_ptr deque list queue stack vector map set pair bitset multiset multimap unordered_set unordered_map unordered_multiset unordered_multimap priority_queue make_pair array shared_ptr abort terminate abs acos asin atan2 atan calloc ceil cosh cos exit exp fabs floor fmod fprintf fputs free frexp fscanf future isalnum isalpha iscntrl isdigit isgraph islower isprint ispunct isspace isupper isxdigit tolower toupper labs ldexp log10 log malloc realloc memchr memcmp memcpy memset modf pow printf putchar puts scanf sinh sin snprintf sprintf sqrt sscanf strcat strchr strcmp strcpy strcspn strlen strncat strncmp strncpy strpbrk strrchr strspn strstr tanh tan vfprintf vprintf vsprintf endl initializer_list unique_ptr"
},g=[o,r,t,e.C_BLOCK_COMMENT_MODE,l,i],m={variants:[{begin:/=/,end:/;/},{
begin:/\(/,end:/\)/},{beginKeywords:"new throw return else",end:/;/}],
keywords:u,contains:g.concat([{begin:/\(/,end:/\)/,keywords:u,
contains:g.concat(["self"]),relevance:0}]),relevance:0},p={
begin:"("+a+"[\\*&\\s]+)+"+d,returnBegin:!0,end:/[{;=]/,excludeEnd:!0,
keywords:u,illegal:/[^\w\s\*&:<>.]/,contains:[{begin:"decltype\\(auto\\)",
keywords:u,relevance:0},{begin:d,returnBegin:!0,contains:[e.inherit(c,{
className:"title.function"})],relevance:0},{relevance:0,match:/,/},{
className:"params",begin:/\(/,end:/\)/,keywords:u,relevance:0,
contains:[t,e.C_BLOCK_COMMENT_MODE,i,l,r,{begin:/\(/,end:/\)/,keywords:u,
relevance:0,contains:["self",t,e.C_BLOCK_COMMENT_MODE,i,l,r]}]
},r,t,e.C_BLOCK_COMMENT_MODE,o]};return{name:"C",aliases:["h"],keywords:u,
disableAutodetect:!0,illegal:"</",contains:[].concat(m,p,g,[o,{
begin:e.IDENT_RE+"::",keywords:u},{className:"class",
beginKeywords:"enum class struct union",end:/[{;:<>=]/,contains:[{
beginKeywords:"final class struct"},e.TITLE_MODE]}]),exports:{preprocessor:o,
strings:i,keywords:u}}}})();hljs.registerLanguage("c",e)})();/*! `perl` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{
const n=e.regex,t=/[dualxmsipngr]{0,12}/,r={$pattern:/[\w.]+/,
keyword:"abs accept alarm and atan2 bind binmode bless break caller chdir chmod chomp chop chown chr chroot close closedir connect continue cos crypt dbmclose dbmopen defined delete die do dump each else elsif endgrent endhostent endnetent endprotoent endpwent endservent eof eval exec exists exit exp fcntl fileno flock for foreach fork format formline getc getgrent getgrgid getgrnam gethostbyaddr gethostbyname gethostent getlogin getnetbyaddr getnetbyname getnetent getpeername getpgrp getpriority getprotobyname getprotobynumber getprotoent getpwent getpwnam getpwuid getservbyname getservbyport getservent getsockname getsockopt given glob gmtime goto grep gt hex if index int ioctl join keys kill last lc lcfirst length link listen local localtime log lstat lt ma map mkdir msgctl msgget msgrcv msgsnd my ne next no not oct open opendir or ord our pack package pipe pop pos print printf prototype push q|0 qq quotemeta qw qx rand read readdir readline readlink readpipe recv redo ref rename require reset return reverse rewinddir rindex rmdir say scalar seek seekdir select semctl semget semop send setgrent sethostent setnetent setpgrp setpriority setprotoent setpwent setservent setsockopt shift shmctl shmget shmread shmwrite shutdown sin sleep socket socketpair sort splice split sprintf sqrt srand stat state study sub substr symlink syscall sysopen sysread sysseek system syswrite tell telldir tie tied time times tr truncate uc ucfirst umask undef unless unlink unpack unshift untie until use utime values vec wait waitpid wantarray warn when while write x|0 xor y|0"
},s={className:"subst",begin:"[$@]\\{",end:"\\}",keywords:r},i={begin:/->\{/,
end:/\}/},a={variants:[{begin:/\$\d/},{
begin:n.concat(/[$%@](\^\w\b|#\w+(::\w+)*|\{\w+\}|\w+(::\w*)*)/,"(?![A-Za-z])(?![@$%])")
},{begin:/[$%@][^\s\w{]/,relevance:0}]
},c=[e.BACKSLASH_ESCAPE,s,a],o=[/!/,/\//,/\|/,/\?/,/'/,/"/,/#/],g=(e,r,s="\\1")=>{
const i="\\1"===s?s:n.concat(s,r)
;return n.concat(n.concat("(?:",e,")"),r,/(?:\\.|[^\\\/])*?/,i,/(?:\\.|[^\\\/])*?/,s,t)
},l=(e,r,s)=>n.concat(n.concat("(?:",e,")"),r,/(?:\\.|[^\\\/])*?/,s,t),d=[a,e.HASH_COMMENT_MODE,e.COMMENT(/^=\w/,/=cut/,{
endsWithParent:!0}),i,{className:"string",contains:c,variants:[{
begin:"q[qwxr]?\\s*\\(",end:"\\)",relevance:5},{begin:"q[qwxr]?\\s*\\[",
end:"\\]",relevance:5},{begin:"q[qwxr]?\\s*\\{",end:"\\}",relevance:5},{
begin:"q[qwxr]?\\s*\\|",end:"\\|",relevance:5},{begin:"q[qwxr]?\\s*<",end:">",
relevance:5},{begin:"qw\\s+q",end:"q",relevance:5},{begin:"'",end:"'",
contains:[e.BACKSLASH_ESCAPE]},{begin:'"',end:'"'},{begin:"`",end:"`",
contains:[e.BACKSLASH_ESCAPE]},{begin:/\{\w+\}/,relevance:0},{
begin:"-?\\w+\\s*=>",relevance:0}]},{className:"number",
begin:"(\\b0[0-7_]+)|(\\b0x[0-9a-fA-F_]+)|(\\b[1-9][0-9_]*(\\.[0-9_]+)?)|[0_]\\b",
relevance:0},{
begin:"(\\/\\/|"+e.RE_STARTERS_RE+"|\\b(split|return|print|reverse|grep)\\b)\\s*",
keywords:"split return print reverse grep",relevance:0,
contains:[e.HASH_COMMENT_MODE,{className:"regexp",variants:[{
begin:g("s|tr|y",n.either(...o,{capture:!0}))},{begin:g("s|tr|y","\\(","\\)")},{
begin:g("s|tr|y","\\[","\\]")},{begin:g("s|tr|y","\\{","\\}")}],relevance:2},{
className:"regexp",variants:[{begin:/(m|qr)\/\//,relevance:0},{
begin:l("(?:m|qr)?",/\//,/\//)},{begin:l("m|qr",n.either(...o,{capture:!0
}),/\1/)},{begin:l("m|qr",/\(/,/\)/)},{begin:l("m|qr",/\[/,/\]/)},{
begin:l("m|qr",/\{/,/\}/)}]}]},{className:"function",beginKeywords:"sub",
end:"(\\s*\\(.*?\\))?[;{]",excludeEnd:!0,relevance:5,contains:[e.TITLE_MODE]},{
begin:"-\\w\\b",relevance:0},{begin:"^__DATA__$",end:"^__END__$",
subLanguage:"mojolicious",contains:[{begin:"^@@.*",end:"$",className:"comment"}]
}];return s.contains=d,i.contains=d,{name:"Perl",aliases:["pl","pm"],keywords:r,
contains:d}}})();hljs.registerLanguage("perl",e)})();/*! `protobuf` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{const t={
match:[/(message|enum|service)\s+/,e.IDENT_RE],scope:{1:"keyword",
2:"title.class"}};return{name:"Protocol Buffers",keywords:{
keyword:["package","import","option","optional","required","repeated","group","oneof"],
type:["double","float","int32","int64","uint32","uint64","sint32","sint64","fixed32","fixed64","sfixed32","sfixed64","bool","string","bytes"],
literal:["true","false"]},
contains:[e.QUOTE_STRING_MODE,e.NUMBER_MODE,e.C_LINE_COMMENT_MODE,e.C_BLOCK_COMMENT_MODE,t,{
className:"function",beginKeywords:"rpc",end:/[{;]/,excludeEnd:!0,
keywords:"rpc returns"},{begin:/^\s*[A-Z_]+(?=\s*=[^\n]+;$)/}]}}})()
;hljs.registerLanguage("protobuf",e)})();/*! `pony` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>({name:"Pony",keywords:{
keyword:"actor addressof and as be break class compile_error compile_intrinsic consume continue delegate digestof do else elseif embed end error for fun if ifdef in interface is isnt lambda let match new not object or primitive recover repeat return struct then trait try type until use var where while with xor",
meta:"iso val tag trn box ref",literal:"this false true"},contains:[{
className:"type",begin:"\\b_?[A-Z][\\w]*",relevance:0},{className:"string",
begin:'"""',end:'"""',relevance:10},{className:"string",begin:'"',end:'"',
contains:[e.BACKSLASH_ESCAPE]},{className:"string",begin:"'",end:"'",
contains:[e.BACKSLASH_ESCAPE],relevance:0},{begin:e.IDENT_RE+"'",relevance:0},{
className:"number",
begin:"(-?)(\\b0[xX][a-fA-F0-9]+|\\b0[bB][01]+|(\\b\\d+(_\\d+)?(\\.\\d*)?|\\.\\d+)([eE][-+]?\\d+)?)",
relevance:0},e.C_LINE_COMMENT_MODE,e.C_BLOCK_COMMENT_MODE]})})()
;hljs.registerLanguage("pony",e)})();/*! `plaintext` grammar compiled for Highlight.js 11.5.1 */
(()=>{var t=(()=>{"use strict";return t=>({name:"Plain text",
aliases:["text","txt"],disableAutodetect:!0})})()
;hljs.registerLanguage("plaintext",t)})();/*! `scheme` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{
const t="[^\\(\\)\\[\\]\\{\\}\",'`;#|\\\\\\s]+",n={$pattern:t,
built_in:"case-lambda call/cc class define-class exit-handler field import inherit init-field interface let*-values let-values let/ec mixin opt-lambda override protect provide public rename require require-for-syntax syntax syntax-case syntax-error unit/sig unless when with-syntax and begin call-with-current-continuation call-with-input-file call-with-output-file case cond define define-syntax delay do dynamic-wind else for-each if lambda let let* let-syntax letrec letrec-syntax map or syntax-rules ' * + , ,@ - ... / ; < <= = => > >= ` abs acos angle append apply asin assoc assq assv atan boolean? caar cadr call-with-input-file call-with-output-file call-with-values car cdddar cddddr cdr ceiling char->integer char-alphabetic? char-ci<=? char-ci<? char-ci=? char-ci>=? char-ci>? char-downcase char-lower-case? char-numeric? char-ready? char-upcase char-upper-case? char-whitespace? char<=? char<? char=? char>=? char>? char? close-input-port close-output-port complex? cons cos current-input-port current-output-port denominator display eof-object? eq? equal? eqv? eval even? exact->inexact exact? exp expt floor force gcd imag-part inexact->exact inexact? input-port? integer->char integer? interaction-environment lcm length list list->string list->vector list-ref list-tail list? load log magnitude make-polar make-rectangular make-string make-vector max member memq memv min modulo negative? newline not null-environment null? number->string number? numerator odd? open-input-file open-output-file output-port? pair? peek-char port? positive? procedure? quasiquote quote quotient rational? rationalize read read-char real-part real? remainder reverse round scheme-report-environment set! set-car! set-cdr! sin sqrt string string->list string->number string->symbol string-append string-ci<=? string-ci<? string-ci=? string-ci>=? string-ci>? string-copy string-fill! string-length string-ref string-set! string<=? string<? string=? string>=? string>? string? substring symbol->string symbol? tan transcript-off transcript-on truncate values vector vector->list vector-fill! vector-length vector-ref vector-set! with-input-from-file with-output-to-file write write-char zero?"
},r={className:"literal",begin:"(#t|#f|#\\\\"+t+"|#\\\\.)"},a={
className:"number",variants:[{begin:"(-|\\+)?\\d+([./]\\d+)?",relevance:0},{
begin:"(-|\\+)?\\d+([./]\\d+)?[+\\-](-|\\+)?\\d+([./]\\d+)?i",relevance:0},{
begin:"#b[0-1]+(/[0-1]+)?"},{begin:"#o[0-7]+(/[0-7]+)?"},{
begin:"#x[0-9a-f]+(/[0-9a-f]+)?"}]},i=e.QUOTE_STRING_MODE,c=[e.COMMENT(";","$",{
relevance:0}),e.COMMENT("#\\|","\\|#")],s={begin:t,relevance:0},l={
className:"symbol",begin:"'"+t},o={endsWithParent:!0,relevance:0},g={variants:[{
begin:/'/},{begin:"`"}],contains:[{begin:"\\(",end:"\\)",
contains:["self",r,i,a,s,l]}]},u={className:"name",relevance:0,begin:t,
keywords:n},d={variants:[{begin:"\\(",end:"\\)"},{begin:"\\[",end:"\\]"}],
contains:[{begin:/lambda/,endsWithParent:!0,returnBegin:!0,contains:[u,{
endsParent:!0,variants:[{begin:/\(/,end:/\)/},{begin:/\[/,end:/\]/}],
contains:[s]}]},u,o]};return o.contains=[r,a,i,s,l,g,d].concat(c),{
name:"Scheme",illegal:/\S/,contains:[e.SHEBANG(),a,i,l,g,d].concat(c)}}})()
;hljs.registerLanguage("scheme",e)})();/*! `haskell` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{const n={
variants:[e.COMMENT("--","$"),e.COMMENT(/\{-/,/-\}/,{contains:["self"]})]},a={
className:"meta",begin:/\{-#/,end:/#-\}/},i={className:"meta",begin:"^#",end:"$"
},s={className:"type",begin:"\\b[A-Z][\\w']*",relevance:0},l={begin:"\\(",
end:"\\)",illegal:'"',contains:[a,i,{className:"type",
begin:"\\b[A-Z][\\w]*(\\((\\.\\.|,|\\w+)\\))?"},e.inherit(e.TITLE_MODE,{
begin:"[_a-z][\\w']*"}),n]},t="([0-9a-fA-F]_*)+",c={className:"number",
relevance:0,variants:[{
match:"\\b(([0-9]_*)+)(\\.(([0-9]_*)+))?([eE][+-]?(([0-9]_*)+))?\\b"},{
match:`\\b0[xX]_*(${t})(\\.(${t}))?([pP][+-]?(([0-9]_*)+))?\\b`},{
match:"\\b0[oO](([0-7]_*)+)\\b"},{match:"\\b0[bB](([01]_*)+)\\b"}]};return{
name:"Haskell",aliases:["hs"],
keywords:"let in if then else case of where do module import hiding qualified type data newtype deriving class instance as default infix infixl infixr foreign export ccall stdcall cplusplus jvm dotnet safe unsafe family forall mdo proc rec",
contains:[{beginKeywords:"module",end:"where",keywords:"module where",
contains:[l,n],illegal:"\\W\\.|;"},{begin:"\\bimport\\b",end:"$",
keywords:"import qualified as hiding",contains:[l,n],illegal:"\\W\\.|;"},{
className:"class",begin:"^(\\s*)?(class|instance)\\b",end:"where",
keywords:"class family instance where",contains:[s,l,n]},{className:"class",
begin:"\\b(data|(new)?type)\\b",end:"$",
keywords:"data family type newtype deriving",contains:[a,s,l,{begin:/\{/,
end:/\}/,contains:l.contains},n]},{beginKeywords:"default",end:"$",
contains:[s,l,n]},{beginKeywords:"infix infixl infixr",end:"$",
contains:[e.C_NUMBER_MODE,n]},{begin:"\\bforeign\\b",end:"$",
keywords:"foreign import export ccall stdcall cplusplus jvm dotnet safe unsafe",
contains:[s,e.QUOTE_STRING_MODE,n]},{className:"meta",
begin:"#!\\/usr\\/bin\\/env runhaskell",end:"$"
},a,i,e.QUOTE_STRING_MODE,c,s,e.inherit(e.TITLE_MODE,{begin:"^[_a-z][\\w']*"
}),n,{begin:"->|<-"}]}}})();hljs.registerLanguage("haskell",e)})();/*! `fortran` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{const n=e.regex,a={
variants:[e.COMMENT("!","$",{relevance:0}),e.COMMENT("^C[ ]","$",{relevance:0
}),e.COMMENT("^C$","$",{relevance:0})]
},t=/(_[a-z_\d]+)?/,i=/([de][+-]?\d+)?/,c={className:"number",variants:[{
begin:n.concat(/\b\d+/,/\.(\d*)/,i,t)},{begin:n.concat(/\b\d+/,i,t)},{
begin:n.concat(/\.\d+/,i,t)}],relevance:0},o={className:"function",
beginKeywords:"subroutine function program",illegal:"[${=\\n]",
contains:[e.UNDERSCORE_TITLE_MODE,{className:"params",begin:"\\(",end:"\\)"}]}
;return{name:"Fortran",case_insensitive:!0,aliases:["f90","f95"],keywords:{
keyword:["kind","do","concurrent","local","shared","while","private","call","intrinsic","where","elsewhere","type","endtype","endmodule","endselect","endinterface","end","enddo","endif","if","forall","endforall","only","contains","default","return","stop","then","block","endblock","endassociate","public","subroutine|10","function","program",".and.",".or.",".not.",".le.",".eq.",".ge.",".gt.",".lt.","goto","save","else","use","module","select","case","access","blank","direct","exist","file","fmt","form","formatted","iostat","name","named","nextrec","number","opened","rec","recl","sequential","status","unformatted","unit","continue","format","pause","cycle","exit","c_null_char","c_alert","c_backspace","c_form_feed","flush","wait","decimal","round","iomsg","synchronous","nopass","non_overridable","pass","protected","volatile","abstract","extends","import","non_intrinsic","value","deferred","generic","final","enumerator","class","associate","bind","enum","c_int","c_short","c_long","c_long_long","c_signed_char","c_size_t","c_int8_t","c_int16_t","c_int32_t","c_int64_t","c_int_least8_t","c_int_least16_t","c_int_least32_t","c_int_least64_t","c_int_fast8_t","c_int_fast16_t","c_int_fast32_t","c_int_fast64_t","c_intmax_t","C_intptr_t","c_float","c_double","c_long_double","c_float_complex","c_double_complex","c_long_double_complex","c_bool","c_char","c_null_ptr","c_null_funptr","c_new_line","c_carriage_return","c_horizontal_tab","c_vertical_tab","iso_c_binding","c_loc","c_funloc","c_associated","c_f_pointer","c_ptr","c_funptr","iso_fortran_env","character_storage_size","error_unit","file_storage_size","input_unit","iostat_end","iostat_eor","numeric_storage_size","output_unit","c_f_procpointer","ieee_arithmetic","ieee_support_underflow_control","ieee_get_underflow_mode","ieee_set_underflow_mode","newunit","contiguous","recursive","pad","position","action","delim","readwrite","eor","advance","nml","interface","procedure","namelist","include","sequence","elemental","pure","impure","integer","real","character","complex","logical","codimension","dimension","allocatable|10","parameter","external","implicit|10","none","double","precision","assign","intent","optional","pointer","target","in","out","common","equivalence","data"],
literal:[".False.",".True."],
built_in:["alog","alog10","amax0","amax1","amin0","amin1","amod","cabs","ccos","cexp","clog","csin","csqrt","dabs","dacos","dasin","datan","datan2","dcos","dcosh","ddim","dexp","dint","dlog","dlog10","dmax1","dmin1","dmod","dnint","dsign","dsin","dsinh","dsqrt","dtan","dtanh","float","iabs","idim","idint","idnint","ifix","isign","max0","max1","min0","min1","sngl","algama","cdabs","cdcos","cdexp","cdlog","cdsin","cdsqrt","cqabs","cqcos","cqexp","cqlog","cqsin","cqsqrt","dcmplx","dconjg","derf","derfc","dfloat","dgamma","dimag","dlgama","iqint","qabs","qacos","qasin","qatan","qatan2","qcmplx","qconjg","qcos","qcosh","qdim","qerf","qerfc","qexp","qgamma","qimag","qlgama","qlog","qlog10","qmax1","qmin1","qmod","qnint","qsign","qsin","qsinh","qsqrt","qtan","qtanh","abs","acos","aimag","aint","anint","asin","atan","atan2","char","cmplx","conjg","cos","cosh","exp","ichar","index","int","log","log10","max","min","nint","sign","sin","sinh","sqrt","tan","tanh","print","write","dim","lge","lgt","lle","llt","mod","nullify","allocate","deallocate","adjustl","adjustr","all","allocated","any","associated","bit_size","btest","ceiling","count","cshift","date_and_time","digits","dot_product","eoshift","epsilon","exponent","floor","fraction","huge","iand","ibclr","ibits","ibset","ieor","ior","ishft","ishftc","lbound","len_trim","matmul","maxexponent","maxloc","maxval","merge","minexponent","minloc","minval","modulo","mvbits","nearest","pack","present","product","radix","random_number","random_seed","range","repeat","reshape","rrspacing","scale","scan","selected_int_kind","selected_real_kind","set_exponent","shape","size","spacing","spread","sum","system_clock","tiny","transpose","trim","ubound","unpack","verify","achar","iachar","transfer","dble","entry","dprod","cpu_time","command_argument_count","get_command","get_command_argument","get_environment_variable","is_iostat_end","ieee_arithmetic","ieee_support_underflow_control","ieee_get_underflow_mode","ieee_set_underflow_mode","is_iostat_eor","move_alloc","new_line","selected_char_kind","same_type_as","extends_type_of","acosh","asinh","atanh","bessel_j0","bessel_j1","bessel_jn","bessel_y0","bessel_y1","bessel_yn","erf","erfc","erfc_scaled","gamma","log_gamma","hypot","norm2","atomic_define","atomic_ref","execute_command_line","leadz","trailz","storage_size","merge_bits","bge","bgt","ble","blt","dshiftl","dshiftr","findloc","iall","iany","iparity","image_index","lcobound","ucobound","maskl","maskr","num_images","parity","popcnt","poppar","shifta","shiftl","shiftr","this_image","sync","change","team","co_broadcast","co_max","co_min","co_sum","co_reduce"]
},illegal:/\/\*/,contains:[{className:"string",relevance:0,
variants:[e.APOS_STRING_MODE,e.QUOTE_STRING_MODE]},o,{begin:/^C\s*=(?!=)/,
relevance:0},a,c]}}})();hljs.registerLanguage("fortran",e)})();/*! `nim` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>({name:"Nim",keywords:{
keyword:["addr","and","as","asm","bind","block","break","case","cast","const","continue","converter","discard","distinct","div","do","elif","else","end","enum","except","export","finally","for","from","func","generic","guarded","if","import","in","include","interface","is","isnot","iterator","let","macro","method","mixin","mod","nil","not","notin","object","of","or","out","proc","ptr","raise","ref","return","shared","shl","shr","static","template","try","tuple","type","using","var","when","while","with","without","xor","yield"],
literal:["true","false"],
type:["int","int8","int16","int32","int64","uint","uint8","uint16","uint32","uint64","float","float32","float64","bool","char","string","cstring","pointer","expr","stmt","void","auto","any","range","array","openarray","varargs","seq","set","clong","culong","cchar","cschar","cshort","cint","csize","clonglong","cfloat","cdouble","clongdouble","cuchar","cushort","cuint","culonglong","cstringarray","semistatic"],
built_in:["stdin","stdout","stderr","result"]},contains:[{className:"meta",
begin:/\{\./,end:/\.\}/,relevance:10},{className:"string",begin:/[a-zA-Z]\w*"/,
end:/"/,contains:[{begin:/""/}]},{className:"string",begin:/([a-zA-Z]\w*)?"""/,
end:/"""/},e.QUOTE_STRING_MODE,{className:"type",begin:/\b[A-Z]\w+\b/,
relevance:0},{className:"number",relevance:0,variants:[{
begin:/\b(0[xX][0-9a-fA-F][_0-9a-fA-F]*)('?[iIuU](8|16|32|64))?/},{
begin:/\b(0o[0-7][_0-7]*)('?[iIuUfF](8|16|32|64))?/},{
begin:/\b(0(b|B)[01][_01]*)('?[iIuUfF](8|16|32|64))?/},{
begin:/\b(\d[_\d]*)('?[iIuUfF](8|16|32|64))?/}]},e.HASH_COMMENT_MODE]})})()
;hljs.registerLanguage("nim",e)})();/*! `ini` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{const n=e.regex,a={className:"number",
relevance:0,variants:[{begin:/([+-]+)?[\d]+_[\d_]+/},{begin:e.NUMBER_RE}]
},s=e.COMMENT();s.variants=[{begin:/;/,end:/$/},{begin:/#/,end:/$/}];const i={
className:"variable",variants:[{begin:/\$[\w\d"][\w\d_]*/},{begin:/\$\{(.*?)\}/
}]},t={className:"literal",begin:/\bon|off|true|false|yes|no\b/},r={
className:"string",contains:[e.BACKSLASH_ESCAPE],variants:[{begin:"'''",
end:"'''",relevance:10},{begin:'"""',end:'"""',relevance:10},{begin:'"',end:'"'
},{begin:"'",end:"'"}]},l={begin:/\[/,end:/\]/,contains:[s,t,i,r,a,"self"],
relevance:0},c=n.either(/[A-Za-z0-9_-]+/,/"(\\"|[^"])*"/,/'[^']*'/);return{
name:"TOML, also INI",aliases:["toml"],case_insensitive:!0,illegal:/\S/,
contains:[s,{className:"section",begin:/\[+/,end:/\]+/},{
begin:n.concat(c,"(\\s*\\.\\s*",c,")*",n.lookahead(/\s*=\s*[^#\s]/)),
className:"attr",starts:{end:/$/,contains:[s,l,t,i,r,a]}}]}}})()
;hljs.registerLanguage("ini",e)})();/*! `json` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>({name:"JSON",contains:[{
className:"attr",begin:/"(\\.|[^\\"\r\n])*"(?=\s*:)/,relevance:1.01},{
match:/[{}[\],:]/,className:"punctuation",relevance:0},e.QUOTE_STRING_MODE,{
beginKeywords:"true false null"
},e.C_NUMBER_MODE,e.C_LINE_COMMENT_MODE,e.C_BLOCK_COMMENT_MODE],illegal:"\\S"})
})();hljs.registerLanguage("json",e)})();/*! `brainfuck` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{const n={className:"literal",
begin:/[+-]+/,relevance:0};return{name:"Brainfuck",aliases:["bf"],
contains:[e.COMMENT(/[^\[\]\.,\+\-<> \r\n]/,/[\[\]\.,\+\-<> \r\n]/,{contains:[{
match:/[ ]+[^\[\]\.,\+\-<> \r\n]/,relevance:0}],returnEnd:!0,relevance:0}),{
className:"title",begin:"[\\[\\]]",relevance:0},{className:"string",
begin:"[\\.,]",relevance:0},{begin:/(?=\+\+|--)/,contains:[n]},n]}}})()
;hljs.registerLanguage("brainfuck",e)})();/*! `cpp` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{const t=e.regex,a=e.COMMENT("//","$",{
contains:[{begin:/\\\n/}]
}),n="[a-zA-Z_]\\w*::",r="(?!struct)(decltype\\(auto\\)|"+t.optional(n)+"[a-zA-Z_]\\w*"+t.optional("<[^<>]+>")+")",i={
className:"type",begin:"\\b[a-z\\d_]*_t\\b"},s={className:"string",variants:[{
begin:'(u8?|U|L)?"',end:'"',illegal:"\\n",contains:[e.BACKSLASH_ESCAPE]},{
begin:"(u8?|U|L)?'(\\\\(x[0-9A-Fa-f]{2}|u[0-9A-Fa-f]{4,8}|[0-7]{3}|\\S)|.)",
end:"'",illegal:"."},e.END_SAME_AS_BEGIN({
begin:/(?:u8?|U|L)?R"([^()\\ ]{0,16})\(/,end:/\)([^()\\ ]{0,16})"/})]},c={
className:"number",variants:[{begin:"\\b(0b[01']+)"},{
begin:"(-?)\\b([\\d']+(\\.[\\d']*)?|\\.[\\d']+)((ll|LL|l|L)(u|U)?|(u|U)(ll|LL|l|L)?|f|F|b|B)"
},{
begin:"(-?)(\\b0[xX][a-fA-F0-9']+|(\\b[\\d']+(\\.[\\d']*)?|\\.[\\d']+)([eE][-+]?[\\d']+)?)"
}],relevance:0},o={className:"meta",begin:/#\s*[a-z]+\b/,end:/$/,keywords:{
keyword:"if else elif endif define undef warning error line pragma _Pragma ifdef ifndef include"
},contains:[{begin:/\\\n/,relevance:0},e.inherit(s,{className:"string"}),{
className:"string",begin:/<.*?>/},a,e.C_BLOCK_COMMENT_MODE]},l={
className:"title",begin:t.optional(n)+e.IDENT_RE,relevance:0
},d=t.optional(n)+e.IDENT_RE+"\\s*\\(",u={
type:["bool","char","char16_t","char32_t","char8_t","double","float","int","long","short","void","wchar_t","unsigned","signed","const","static"],
keyword:["alignas","alignof","and","and_eq","asm","atomic_cancel","atomic_commit","atomic_noexcept","auto","bitand","bitor","break","case","catch","class","co_await","co_return","co_yield","compl","concept","const_cast|10","consteval","constexpr","constinit","continue","decltype","default","delete","do","dynamic_cast|10","else","enum","explicit","export","extern","false","final","for","friend","goto","if","import","inline","module","mutable","namespace","new","noexcept","not","not_eq","nullptr","operator","or","or_eq","override","private","protected","public","reflexpr","register","reinterpret_cast|10","requires","return","sizeof","static_assert","static_cast|10","struct","switch","synchronized","template","this","thread_local","throw","transaction_safe","transaction_safe_dynamic","true","try","typedef","typeid","typename","union","using","virtual","volatile","while","xor","xor_eq"],
literal:["NULL","false","nullopt","nullptr","true"],built_in:["_Pragma"],
_type_hints:["any","auto_ptr","barrier","binary_semaphore","bitset","complex","condition_variable","condition_variable_any","counting_semaphore","deque","false_type","future","imaginary","initializer_list","istringstream","jthread","latch","lock_guard","multimap","multiset","mutex","optional","ostringstream","packaged_task","pair","promise","priority_queue","queue","recursive_mutex","recursive_timed_mutex","scoped_lock","set","shared_future","shared_lock","shared_mutex","shared_timed_mutex","shared_ptr","stack","string_view","stringstream","timed_mutex","thread","true_type","tuple","unique_lock","unique_ptr","unordered_map","unordered_multimap","unordered_multiset","unordered_set","variant","vector","weak_ptr","wstring","wstring_view"]
},p={className:"function.dispatch",relevance:0,keywords:{
_hint:["abort","abs","acos","apply","as_const","asin","atan","atan2","calloc","ceil","cerr","cin","clog","cos","cosh","cout","declval","endl","exchange","exit","exp","fabs","floor","fmod","forward","fprintf","fputs","free","frexp","fscanf","future","invoke","isalnum","isalpha","iscntrl","isdigit","isgraph","islower","isprint","ispunct","isspace","isupper","isxdigit","labs","launder","ldexp","log","log10","make_pair","make_shared","make_shared_for_overwrite","make_tuple","make_unique","malloc","memchr","memcmp","memcpy","memset","modf","move","pow","printf","putchar","puts","realloc","scanf","sin","sinh","snprintf","sprintf","sqrt","sscanf","std","stderr","stdin","stdout","strcat","strchr","strcmp","strcpy","strcspn","strlen","strncat","strncmp","strncpy","strpbrk","strrchr","strspn","strstr","swap","tan","tanh","terminate","to_underlying","tolower","toupper","vfprintf","visit","vprintf","vsprintf"]
},
begin:t.concat(/\b/,/(?!decltype)/,/(?!if)/,/(?!for)/,/(?!switch)/,/(?!while)/,e.IDENT_RE,t.lookahead(/(<[^<>]+>|)\s*\(/))
},_=[p,o,i,a,e.C_BLOCK_COMMENT_MODE,c,s],m={variants:[{begin:/=/,end:/;/},{
begin:/\(/,end:/\)/},{beginKeywords:"new throw return else",end:/;/}],
keywords:u,contains:_.concat([{begin:/\(/,end:/\)/,keywords:u,
contains:_.concat(["self"]),relevance:0}]),relevance:0},g={className:"function",
begin:"("+r+"[\\*&\\s]+)+"+d,returnBegin:!0,end:/[{;=]/,excludeEnd:!0,
keywords:u,illegal:/[^\w\s\*&:<>.]/,contains:[{begin:"decltype\\(auto\\)",
keywords:u,relevance:0},{begin:d,returnBegin:!0,contains:[l],relevance:0},{
begin:/::/,relevance:0},{begin:/:/,endsWithParent:!0,contains:[s,c]},{
relevance:0,match:/,/},{className:"params",begin:/\(/,end:/\)/,keywords:u,
relevance:0,contains:[a,e.C_BLOCK_COMMENT_MODE,s,c,i,{begin:/\(/,end:/\)/,
keywords:u,relevance:0,contains:["self",a,e.C_BLOCK_COMMENT_MODE,s,c,i]}]
},i,a,e.C_BLOCK_COMMENT_MODE,o]};return{name:"C++",
aliases:["cc","c++","h++","hpp","hh","hxx","cxx"],keywords:u,illegal:"</",
classNameAliases:{"function.dispatch":"built_in"},
contains:[].concat(m,g,p,_,[o,{
begin:"\\b(deque|list|queue|priority_queue|pair|stack|vector|map|set|bitset|multiset|multimap|unordered_map|unordered_set|unordered_multiset|unordered_multimap|array|tuple|optional|variant|function)\\s*<(?!<)",
end:">",keywords:u,contains:["self",i]},{begin:e.IDENT_RE+"::",keywords:u},{
match:[/\b(?:enum(?:\s+(?:class|struct))?|class|struct|union)/,/\s+/,/\w+/],
className:{1:"keyword",3:"title.class"}}])}}})();hljs.registerLanguage("cpp",e)
})();/*! `python` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{
const n=e.regex,a=/[\p{XID_Start}_]\p{XID_Continue}*/u,i=["and","as","assert","async","await","break","class","continue","def","del","elif","else","except","finally","for","from","global","if","import","in","is","lambda","nonlocal|10","not","or","pass","raise","return","try","while","with","yield"],s={
$pattern:/[A-Za-z]\w+|__\w+__/,keyword:i,
built_in:["__import__","abs","all","any","ascii","bin","bool","breakpoint","bytearray","bytes","callable","chr","classmethod","compile","complex","delattr","dict","dir","divmod","enumerate","eval","exec","filter","float","format","frozenset","getattr","globals","hasattr","hash","help","hex","id","input","int","isinstance","issubclass","iter","len","list","locals","map","max","memoryview","min","next","object","oct","open","ord","pow","print","property","range","repr","reversed","round","set","setattr","slice","sorted","staticmethod","str","sum","super","tuple","type","vars","zip"],
literal:["__debug__","Ellipsis","False","None","NotImplemented","True"],
type:["Any","Callable","Coroutine","Dict","List","Literal","Generic","Optional","Sequence","Set","Tuple","Type","Union"]
},t={className:"meta",begin:/^(>>>|\.\.\.) /},r={className:"subst",begin:/\{/,
end:/\}/,keywords:s,illegal:/#/},l={begin:/\{\{/,relevance:0},b={
className:"string",contains:[e.BACKSLASH_ESCAPE],variants:[{
begin:/([uU]|[bB]|[rR]|[bB][rR]|[rR][bB])?'''/,end:/'''/,
contains:[e.BACKSLASH_ESCAPE,t],relevance:10},{
begin:/([uU]|[bB]|[rR]|[bB][rR]|[rR][bB])?"""/,end:/"""/,
contains:[e.BACKSLASH_ESCAPE,t],relevance:10},{
begin:/([fF][rR]|[rR][fF]|[fF])'''/,end:/'''/,
contains:[e.BACKSLASH_ESCAPE,t,l,r]},{begin:/([fF][rR]|[rR][fF]|[fF])"""/,
end:/"""/,contains:[e.BACKSLASH_ESCAPE,t,l,r]},{begin:/([uU]|[rR])'/,end:/'/,
relevance:10},{begin:/([uU]|[rR])"/,end:/"/,relevance:10},{
begin:/([bB]|[bB][rR]|[rR][bB])'/,end:/'/},{begin:/([bB]|[bB][rR]|[rR][bB])"/,
end:/"/},{begin:/([fF][rR]|[rR][fF]|[fF])'/,end:/'/,
contains:[e.BACKSLASH_ESCAPE,l,r]},{begin:/([fF][rR]|[rR][fF]|[fF])"/,end:/"/,
contains:[e.BACKSLASH_ESCAPE,l,r]},e.APOS_STRING_MODE,e.QUOTE_STRING_MODE]
},o="[0-9](_?[0-9])*",c=`(\\b(${o}))?\\.(${o})|\\b(${o})\\.`,d="\\b|"+i.join("|"),g={
className:"number",relevance:0,variants:[{
begin:`(\\b(${o})|(${c}))[eE][+-]?(${o})[jJ]?(?=${d})`},{begin:`(${c})[jJ]?`},{
begin:`\\b([1-9](_?[0-9])*|0+(_?0)*)[lLjJ]?(?=${d})`},{
begin:`\\b0[bB](_?[01])+[lL]?(?=${d})`},{begin:`\\b0[oO](_?[0-7])+[lL]?(?=${d})`
},{begin:`\\b0[xX](_?[0-9a-fA-F])+[lL]?(?=${d})`},{begin:`\\b(${o})[jJ](?=${d})`
}]},p={className:"comment",begin:n.lookahead(/# type:/),end:/$/,keywords:s,
contains:[{begin:/# type:/},{begin:/#/,end:/\b\B/,endsWithParent:!0}]},m={
className:"params",variants:[{className:"",begin:/\(\s*\)/,skip:!0},{begin:/\(/,
end:/\)/,excludeBegin:!0,excludeEnd:!0,keywords:s,
contains:["self",t,g,b,e.HASH_COMMENT_MODE]}]};return r.contains=[b,g,t],{
name:"Python",aliases:["py","gyp","ipython"],unicodeRegex:!0,keywords:s,
illegal:/(<\/|->|\?)|=>/,contains:[t,g,{begin:/\bself\b/},{beginKeywords:"if",
relevance:0},b,p,e.HASH_COMMENT_MODE,{match:[/\bdef/,/\s+/,a],scope:{
1:"keyword",3:"title.function"},contains:[m]},{variants:[{
match:[/\bclass/,/\s+/,a,/\s*/,/\(\s*/,a,/\s*\)/]},{match:[/\bclass/,/\s+/,a]}],
scope:{1:"keyword",3:"title.class",6:"title.class.inherited"}},{
className:"meta",begin:/^[\t ]*@/,end:/(?=#)|$/,contains:[g,m,b]}]}}})()
;hljs.registerLanguage("python",e)})();/*! `java` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict"
;var e="\\.([0-9](_*[0-9])*)",a="[0-9a-fA-F](_*[0-9a-fA-F])*",n={
className:"number",variants:[{
begin:`(\\b([0-9](_*[0-9])*)((${e})|\\.)?|(${e}))[eE][+-]?([0-9](_*[0-9])*)[fFdD]?\\b`
},{begin:`\\b([0-9](_*[0-9])*)((${e})[fFdD]?\\b|\\.([fFdD]\\b)?)`},{
begin:`(${e})[fFdD]?\\b`},{begin:"\\b([0-9](_*[0-9])*)[fFdD]\\b"},{
begin:`\\b0[xX]((${a})\\.?|(${a})?\\.(${a}))[pP][+-]?([0-9](_*[0-9])*)[fFdD]?\\b`
},{begin:"\\b(0|[1-9](_*[0-9])*)[lL]?\\b"},{begin:`\\b0[xX](${a})[lL]?\\b`},{
begin:"\\b0(_*[0-7])*[lL]?\\b"},{begin:"\\b0[bB][01](_*[01])*[lL]?\\b"}],
relevance:0};function s(e,a,n){return-1===n?"":e.replace(a,(t=>s(e,a,n-1)))}
return e=>{
const a=e.regex,t="[\xc0-\u02b8a-zA-Z_$][\xc0-\u02b8a-zA-Z_$0-9]*",i=t+s("(?:<"+t+"~~~(?:\\s*,\\s*"+t+"~~~)*>)?",/~~~/g,2),r={
keyword:["synchronized","abstract","private","var","static","if","const ","for","while","strictfp","finally","protected","import","native","final","void","enum","else","break","transient","catch","instanceof","volatile","case","assert","package","default","public","try","switch","continue","throws","protected","public","private","module","requires","exports","do","sealed"],
literal:["false","true","null"],
type:["char","boolean","long","float","int","byte","short","double"],
built_in:["super","this"]},l={className:"meta",begin:"@"+t,contains:[{
begin:/\(/,end:/\)/,contains:["self"]}]},c={className:"params",begin:/\(/,
end:/\)/,keywords:r,relevance:0,contains:[e.C_BLOCK_COMMENT_MODE],endsParent:!0}
;return{name:"Java",aliases:["jsp"],keywords:r,illegal:/<\/|#/,
contains:[e.COMMENT("/\\*\\*","\\*/",{relevance:0,contains:[{begin:/\w+@/,
relevance:0},{className:"doctag",begin:"@[A-Za-z]+"}]}),{
begin:/import java\.[a-z]+\./,keywords:"import",relevance:2
},e.C_LINE_COMMENT_MODE,e.C_BLOCK_COMMENT_MODE,{begin:/"""/,end:/"""/,
className:"string",contains:[e.BACKSLASH_ESCAPE]
},e.APOS_STRING_MODE,e.QUOTE_STRING_MODE,{
match:[/\b(?:class|interface|enum|extends|implements|new)/,/\s+/,t],className:{
1:"keyword",3:"title.class"}},{match:/non-sealed/,scope:"keyword"},{
begin:[a.concat(/(?!else)/,t),/\s+/,t,/\s+/,/=/],className:{1:"type",
3:"variable",5:"operator"}},{begin:[/record/,/\s+/,t],className:{1:"keyword",
3:"title.class"},contains:[c,e.C_LINE_COMMENT_MODE,e.C_BLOCK_COMMENT_MODE]},{
beginKeywords:"new throw return else",relevance:0},{
begin:["(?:"+i+"\\s+)",e.UNDERSCORE_IDENT_RE,/\s*(?=\()/],className:{
2:"title.function"},keywords:r,contains:[{className:"params",begin:/\(/,
end:/\)/,keywords:r,relevance:0,
contains:[l,e.APOS_STRING_MODE,e.QUOTE_STRING_MODE,n,e.C_BLOCK_COMMENT_MODE]
},e.C_LINE_COMMENT_MODE,e.C_BLOCK_COMMENT_MODE]},n,l]}}})()
;hljs.registerLanguage("java",e)})();/*! `mathematica` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict"
;const e=["AASTriangle","AbelianGroup","Abort","AbortKernels","AbortProtect","AbortScheduledTask","Above","Abs","AbsArg","AbsArgPlot","Absolute","AbsoluteCorrelation","AbsoluteCorrelationFunction","AbsoluteCurrentValue","AbsoluteDashing","AbsoluteFileName","AbsoluteOptions","AbsolutePointSize","AbsoluteThickness","AbsoluteTime","AbsoluteTiming","AcceptanceThreshold","AccountingForm","Accumulate","Accuracy","AccuracyGoal","ActionDelay","ActionMenu","ActionMenuBox","ActionMenuBoxOptions","Activate","Active","ActiveClassification","ActiveClassificationObject","ActiveItem","ActivePrediction","ActivePredictionObject","ActiveStyle","AcyclicGraphQ","AddOnHelpPath","AddSides","AddTo","AddToSearchIndex","AddUsers","AdjacencyGraph","AdjacencyList","AdjacencyMatrix","AdjacentMeshCells","AdjustmentBox","AdjustmentBoxOptions","AdjustTimeSeriesForecast","AdministrativeDivisionData","AffineHalfSpace","AffineSpace","AffineStateSpaceModel","AffineTransform","After","AggregatedEntityClass","AggregationLayer","AircraftData","AirportData","AirPressureData","AirTemperatureData","AiryAi","AiryAiPrime","AiryAiZero","AiryBi","AiryBiPrime","AiryBiZero","AlgebraicIntegerQ","AlgebraicNumber","AlgebraicNumberDenominator","AlgebraicNumberNorm","AlgebraicNumberPolynomial","AlgebraicNumberTrace","AlgebraicRules","AlgebraicRulesData","Algebraics","AlgebraicUnitQ","Alignment","AlignmentMarker","AlignmentPoint","All","AllowAdultContent","AllowedCloudExtraParameters","AllowedCloudParameterExtensions","AllowedDimensions","AllowedFrequencyRange","AllowedHeads","AllowGroupClose","AllowIncomplete","AllowInlineCells","AllowKernelInitialization","AllowLooseGrammar","AllowReverseGroupClose","AllowScriptLevelChange","AllowVersionUpdate","AllTrue","Alphabet","AlphabeticOrder","AlphabeticSort","AlphaChannel","AlternateImage","AlternatingFactorial","AlternatingGroup","AlternativeHypothesis","Alternatives","AltitudeMethod","AmbientLight","AmbiguityFunction","AmbiguityList","Analytic","AnatomyData","AnatomyForm","AnatomyPlot3D","AnatomySkinStyle","AnatomyStyling","AnchoredSearch","And","AndersonDarlingTest","AngerJ","AngleBisector","AngleBracket","AnglePath","AnglePath3D","AngleVector","AngularGauge","Animate","AnimationCycleOffset","AnimationCycleRepetitions","AnimationDirection","AnimationDisplayTime","AnimationRate","AnimationRepetitions","AnimationRunning","AnimationRunTime","AnimationTimeIndex","Animator","AnimatorBox","AnimatorBoxOptions","AnimatorElements","Annotate","Annotation","AnnotationDelete","AnnotationKeys","AnnotationRules","AnnotationValue","Annuity","AnnuityDue","Annulus","AnomalyDetection","AnomalyDetector","AnomalyDetectorFunction","Anonymous","Antialiasing","AntihermitianMatrixQ","Antisymmetric","AntisymmetricMatrixQ","Antonyms","AnyOrder","AnySubset","AnyTrue","Apart","ApartSquareFree","APIFunction","Appearance","AppearanceElements","AppearanceRules","AppellF1","Append","AppendCheck","AppendLayer","AppendTo","Apply","ApplySides","ArcCos","ArcCosh","ArcCot","ArcCoth","ArcCsc","ArcCsch","ArcCurvature","ARCHProcess","ArcLength","ArcSec","ArcSech","ArcSin","ArcSinDistribution","ArcSinh","ArcTan","ArcTanh","Area","Arg","ArgMax","ArgMin","ArgumentCountQ","ARIMAProcess","ArithmeticGeometricMean","ARMAProcess","Around","AroundReplace","ARProcess","Array","ArrayComponents","ArrayDepth","ArrayFilter","ArrayFlatten","ArrayMesh","ArrayPad","ArrayPlot","ArrayQ","ArrayResample","ArrayReshape","ArrayRules","Arrays","Arrow","Arrow3DBox","ArrowBox","Arrowheads","ASATriangle","Ask","AskAppend","AskConfirm","AskDisplay","AskedQ","AskedValue","AskFunction","AskState","AskTemplateDisplay","AspectRatio","AspectRatioFixed","Assert","AssociateTo","Association","AssociationFormat","AssociationMap","AssociationQ","AssociationThread","AssumeDeterministic","Assuming","Assumptions","AstronomicalData","Asymptotic","AsymptoticDSolveValue","AsymptoticEqual","AsymptoticEquivalent","AsymptoticGreater","AsymptoticGreaterEqual","AsymptoticIntegrate","AsymptoticLess","AsymptoticLessEqual","AsymptoticOutputTracker","AsymptoticProduct","AsymptoticRSolveValue","AsymptoticSolve","AsymptoticSum","Asynchronous","AsynchronousTaskObject","AsynchronousTasks","Atom","AtomCoordinates","AtomCount","AtomDiagramCoordinates","AtomList","AtomQ","AttentionLayer","Attributes","Audio","AudioAmplify","AudioAnnotate","AudioAnnotationLookup","AudioBlockMap","AudioCapture","AudioChannelAssignment","AudioChannelCombine","AudioChannelMix","AudioChannels","AudioChannelSeparate","AudioData","AudioDelay","AudioDelete","AudioDevice","AudioDistance","AudioEncoding","AudioFade","AudioFrequencyShift","AudioGenerator","AudioIdentify","AudioInputDevice","AudioInsert","AudioInstanceQ","AudioIntervals","AudioJoin","AudioLabel","AudioLength","AudioLocalMeasurements","AudioLooping","AudioLoudness","AudioMeasurements","AudioNormalize","AudioOutputDevice","AudioOverlay","AudioPad","AudioPan","AudioPartition","AudioPause","AudioPitchShift","AudioPlay","AudioPlot","AudioQ","AudioRecord","AudioReplace","AudioResample","AudioReverb","AudioReverse","AudioSampleRate","AudioSpectralMap","AudioSpectralTransformation","AudioSplit","AudioStop","AudioStream","AudioStreams","AudioTimeStretch","AudioTracks","AudioTrim","AudioType","AugmentedPolyhedron","AugmentedSymmetricPolynomial","Authenticate","Authentication","AuthenticationDialog","AutoAction","Autocomplete","AutocompletionFunction","AutoCopy","AutocorrelationTest","AutoDelete","AutoEvaluateEvents","AutoGeneratedPackage","AutoIndent","AutoIndentSpacings","AutoItalicWords","AutoloadPath","AutoMatch","Automatic","AutomaticImageSize","AutoMultiplicationSymbol","AutoNumberFormatting","AutoOpenNotebooks","AutoOpenPalettes","AutoQuoteCharacters","AutoRefreshed","AutoRemove","AutorunSequencing","AutoScaling","AutoScroll","AutoSpacing","AutoStyleOptions","AutoStyleWords","AutoSubmitting","Axes","AxesEdge","AxesLabel","AxesOrigin","AxesStyle","AxiomaticTheory","Axis","BabyMonsterGroupB","Back","Background","BackgroundAppearance","BackgroundTasksSettings","Backslash","Backsubstitution","Backward","Ball","Band","BandpassFilter","BandstopFilter","BarabasiAlbertGraphDistribution","BarChart","BarChart3D","BarcodeImage","BarcodeRecognize","BaringhausHenzeTest","BarLegend","BarlowProschanImportance","BarnesG","BarOrigin","BarSpacing","BartlettHannWindow","BartlettWindow","BaseDecode","BaseEncode","BaseForm","Baseline","BaselinePosition","BaseStyle","BasicRecurrentLayer","BatchNormalizationLayer","BatchSize","BatesDistribution","BattleLemarieWavelet","BayesianMaximization","BayesianMaximizationObject","BayesianMinimization","BayesianMinimizationObject","Because","BeckmannDistribution","Beep","Before","Begin","BeginDialogPacket","BeginFrontEndInteractionPacket","BeginPackage","BellB","BellY","Below","BenfordDistribution","BeniniDistribution","BenktanderGibratDistribution","BenktanderWeibullDistribution","BernoulliB","BernoulliDistribution","BernoulliGraphDistribution","BernoulliProcess","BernsteinBasis","BesselFilterModel","BesselI","BesselJ","BesselJZero","BesselK","BesselY","BesselYZero","Beta","BetaBinomialDistribution","BetaDistribution","BetaNegativeBinomialDistribution","BetaPrimeDistribution","BetaRegularized","Between","BetweennessCentrality","BeveledPolyhedron","BezierCurve","BezierCurve3DBox","BezierCurve3DBoxOptions","BezierCurveBox","BezierCurveBoxOptions","BezierFunction","BilateralFilter","Binarize","BinaryDeserialize","BinaryDistance","BinaryFormat","BinaryImageQ","BinaryRead","BinaryReadList","BinarySerialize","BinaryWrite","BinCounts","BinLists","Binomial","BinomialDistribution","BinomialProcess","BinormalDistribution","BiorthogonalSplineWavelet","BipartiteGraphQ","BiquadraticFilterModel","BirnbaumImportance","BirnbaumSaundersDistribution","BitAnd","BitClear","BitGet","BitLength","BitNot","BitOr","BitSet","BitShiftLeft","BitShiftRight","BitXor","BiweightLocation","BiweightMidvariance","Black","BlackmanHarrisWindow","BlackmanNuttallWindow","BlackmanWindow","Blank","BlankForm","BlankNullSequence","BlankSequence","Blend","Block","BlockchainAddressData","BlockchainBase","BlockchainBlockData","BlockchainContractValue","BlockchainData","BlockchainGet","BlockchainKeyEncode","BlockchainPut","BlockchainTokenData","BlockchainTransaction","BlockchainTransactionData","BlockchainTransactionSign","BlockchainTransactionSubmit","BlockMap","BlockRandom","BlomqvistBeta","BlomqvistBetaTest","Blue","Blur","BodePlot","BohmanWindow","Bold","Bond","BondCount","BondList","BondQ","Bookmarks","Boole","BooleanConsecutiveFunction","BooleanConvert","BooleanCountingFunction","BooleanFunction","BooleanGraph","BooleanMaxterms","BooleanMinimize","BooleanMinterms","BooleanQ","BooleanRegion","Booleans","BooleanStrings","BooleanTable","BooleanVariables","BorderDimensions","BorelTannerDistribution","Bottom","BottomHatTransform","BoundaryDiscretizeGraphics","BoundaryDiscretizeRegion","BoundaryMesh","BoundaryMeshRegion","BoundaryMeshRegionQ","BoundaryStyle","BoundedRegionQ","BoundingRegion","Bounds","Box","BoxBaselineShift","BoxData","BoxDimensions","Boxed","Boxes","BoxForm","BoxFormFormatTypes","BoxFrame","BoxID","BoxMargins","BoxMatrix","BoxObject","BoxRatios","BoxRotation","BoxRotationPoint","BoxStyle","BoxWhiskerChart","Bra","BracketingBar","BraKet","BrayCurtisDistance","BreadthFirstScan","Break","BridgeData","BrightnessEqualize","BroadcastStationData","Brown","BrownForsytheTest","BrownianBridgeProcess","BrowserCategory","BSplineBasis","BSplineCurve","BSplineCurve3DBox","BSplineCurve3DBoxOptions","BSplineCurveBox","BSplineCurveBoxOptions","BSplineFunction","BSplineSurface","BSplineSurface3DBox","BSplineSurface3DBoxOptions","BubbleChart","BubbleChart3D","BubbleScale","BubbleSizes","BuildingData","BulletGauge","BusinessDayQ","ButterflyGraph","ButterworthFilterModel","Button","ButtonBar","ButtonBox","ButtonBoxOptions","ButtonCell","ButtonContents","ButtonData","ButtonEvaluator","ButtonExpandable","ButtonFrame","ButtonFunction","ButtonMargins","ButtonMinHeight","ButtonNote","ButtonNotebook","ButtonSource","ButtonStyle","ButtonStyleMenuListing","Byte","ByteArray","ByteArrayFormat","ByteArrayQ","ByteArrayToString","ByteCount","ByteOrdering","C","CachedValue","CacheGraphics","CachePersistence","CalendarConvert","CalendarData","CalendarType","Callout","CalloutMarker","CalloutStyle","CallPacket","CanberraDistance","Cancel","CancelButton","CandlestickChart","CanonicalGraph","CanonicalizePolygon","CanonicalizePolyhedron","CanonicalName","CanonicalWarpingCorrespondence","CanonicalWarpingDistance","CantorMesh","CantorStaircase","Cap","CapForm","CapitalDifferentialD","Capitalize","CapsuleShape","CaptureRunning","CardinalBSplineBasis","CarlemanLinearize","CarmichaelLambda","CaseOrdering","Cases","CaseSensitive","Cashflow","Casoratian","Catalan","CatalanNumber","Catch","CategoricalDistribution","Catenate","CatenateLayer","CauchyDistribution","CauchyWindow","CayleyGraph","CDF","CDFDeploy","CDFInformation","CDFWavelet","Ceiling","CelestialSystem","Cell","CellAutoOverwrite","CellBaseline","CellBoundingBox","CellBracketOptions","CellChangeTimes","CellContents","CellContext","CellDingbat","CellDynamicExpression","CellEditDuplicate","CellElementsBoundingBox","CellElementSpacings","CellEpilog","CellEvaluationDuplicate","CellEvaluationFunction","CellEvaluationLanguage","CellEventActions","CellFrame","CellFrameColor","CellFrameLabelMargins","CellFrameLabels","CellFrameMargins","CellGroup","CellGroupData","CellGrouping","CellGroupingRules","CellHorizontalScrolling","CellID","CellLabel","CellLabelAutoDelete","CellLabelMargins","CellLabelPositioning","CellLabelStyle","CellLabelTemplate","CellMargins","CellObject","CellOpen","CellPrint","CellProlog","Cells","CellSize","CellStyle","CellTags","CellularAutomaton","CensoredDistribution","Censoring","Center","CenterArray","CenterDot","CentralFeature","CentralMoment","CentralMomentGeneratingFunction","Cepstrogram","CepstrogramArray","CepstrumArray","CForm","ChampernowneNumber","ChangeOptions","ChannelBase","ChannelBrokerAction","ChannelDatabin","ChannelHistoryLength","ChannelListen","ChannelListener","ChannelListeners","ChannelListenerWait","ChannelObject","ChannelPreSendFunction","ChannelReceiverFunction","ChannelSend","ChannelSubscribers","ChanVeseBinarize","Character","CharacterCounts","CharacterEncoding","CharacterEncodingsPath","CharacteristicFunction","CharacteristicPolynomial","CharacterName","CharacterNormalize","CharacterRange","Characters","ChartBaseStyle","ChartElementData","ChartElementDataFunction","ChartElementFunction","ChartElements","ChartLabels","ChartLayout","ChartLegends","ChartStyle","Chebyshev1FilterModel","Chebyshev2FilterModel","ChebyshevDistance","ChebyshevT","ChebyshevU","Check","CheckAbort","CheckAll","Checkbox","CheckboxBar","CheckboxBox","CheckboxBoxOptions","ChemicalData","ChessboardDistance","ChiDistribution","ChineseRemainder","ChiSquareDistribution","ChoiceButtons","ChoiceDialog","CholeskyDecomposition","Chop","ChromaticityPlot","ChromaticityPlot3D","ChromaticPolynomial","Circle","CircleBox","CircleDot","CircleMinus","CirclePlus","CirclePoints","CircleThrough","CircleTimes","CirculantGraph","CircularOrthogonalMatrixDistribution","CircularQuaternionMatrixDistribution","CircularRealMatrixDistribution","CircularSymplecticMatrixDistribution","CircularUnitaryMatrixDistribution","Circumsphere","CityData","ClassifierFunction","ClassifierInformation","ClassifierMeasurements","ClassifierMeasurementsObject","Classify","ClassPriors","Clear","ClearAll","ClearAttributes","ClearCookies","ClearPermissions","ClearSystemCache","ClebschGordan","ClickPane","Clip","ClipboardNotebook","ClipFill","ClippingStyle","ClipPlanes","ClipPlanesStyle","ClipRange","Clock","ClockGauge","ClockwiseContourIntegral","Close","Closed","CloseKernels","ClosenessCentrality","Closing","ClosingAutoSave","ClosingEvent","ClosingSaveDialog","CloudAccountData","CloudBase","CloudConnect","CloudConnections","CloudDeploy","CloudDirectory","CloudDisconnect","CloudEvaluate","CloudExport","CloudExpression","CloudExpressions","CloudFunction","CloudGet","CloudImport","CloudLoggingData","CloudObject","CloudObjectInformation","CloudObjectInformationData","CloudObjectNameFormat","CloudObjects","CloudObjectURLType","CloudPublish","CloudPut","CloudRenderingMethod","CloudSave","CloudShare","CloudSubmit","CloudSymbol","CloudUnshare","CloudUserID","ClusterClassify","ClusterDissimilarityFunction","ClusteringComponents","ClusteringTree","CMYKColor","Coarse","CodeAssistOptions","Coefficient","CoefficientArrays","CoefficientDomain","CoefficientList","CoefficientRules","CoifletWavelet","Collect","Colon","ColonForm","ColorBalance","ColorCombine","ColorConvert","ColorCoverage","ColorData","ColorDataFunction","ColorDetect","ColorDistance","ColorFunction","ColorFunctionScaling","Colorize","ColorNegate","ColorOutput","ColorProfileData","ColorQ","ColorQuantize","ColorReplace","ColorRules","ColorSelectorSettings","ColorSeparate","ColorSetter","ColorSetterBox","ColorSetterBoxOptions","ColorSlider","ColorsNear","ColorSpace","ColorToneMapping","Column","ColumnAlignments","ColumnBackgrounds","ColumnForm","ColumnLines","ColumnsEqual","ColumnSpacings","ColumnWidths","CombinedEntityClass","CombinerFunction","CometData","CommonDefaultFormatTypes","Commonest","CommonestFilter","CommonName","CommonUnits","CommunityBoundaryStyle","CommunityGraphPlot","CommunityLabels","CommunityRegionStyle","CompanyData","CompatibleUnitQ","CompilationOptions","CompilationTarget","Compile","Compiled","CompiledCodeFunction","CompiledFunction","CompilerOptions","Complement","ComplementedEntityClass","CompleteGraph","CompleteGraphQ","CompleteKaryTree","CompletionsListPacket","Complex","ComplexContourPlot","Complexes","ComplexExpand","ComplexInfinity","ComplexityFunction","ComplexListPlot","ComplexPlot","ComplexPlot3D","ComplexRegionPlot","ComplexStreamPlot","ComplexVectorPlot","ComponentMeasurements","ComponentwiseContextMenu","Compose","ComposeList","ComposeSeries","CompositeQ","Composition","CompoundElement","CompoundExpression","CompoundPoissonDistribution","CompoundPoissonProcess","CompoundRenewalProcess","Compress","CompressedData","CompressionLevel","ComputeUncertainty","Condition","ConditionalExpression","Conditioned","Cone","ConeBox","ConfidenceLevel","ConfidenceRange","ConfidenceTransform","ConfigurationPath","ConformAudio","ConformImages","Congruent","ConicHullRegion","ConicHullRegion3DBox","ConicHullRegionBox","ConicOptimization","Conjugate","ConjugateTranspose","Conjunction","Connect","ConnectedComponents","ConnectedGraphComponents","ConnectedGraphQ","ConnectedMeshComponents","ConnectedMoleculeComponents","ConnectedMoleculeQ","ConnectionSettings","ConnectLibraryCallbackFunction","ConnectSystemModelComponents","ConnesWindow","ConoverTest","ConsoleMessage","ConsoleMessagePacket","Constant","ConstantArray","ConstantArrayLayer","ConstantImage","ConstantPlusLayer","ConstantRegionQ","Constants","ConstantTimesLayer","ConstellationData","ConstrainedMax","ConstrainedMin","Construct","Containing","ContainsAll","ContainsAny","ContainsExactly","ContainsNone","ContainsOnly","ContentFieldOptions","ContentLocationFunction","ContentObject","ContentPadding","ContentsBoundingBox","ContentSelectable","ContentSize","Context","ContextMenu","Contexts","ContextToFileName","Continuation","Continue","ContinuedFraction","ContinuedFractionK","ContinuousAction","ContinuousMarkovProcess","ContinuousTask","ContinuousTimeModelQ","ContinuousWaveletData","ContinuousWaveletTransform","ContourDetect","ContourGraphics","ContourIntegral","ContourLabels","ContourLines","ContourPlot","ContourPlot3D","Contours","ContourShading","ContourSmoothing","ContourStyle","ContraharmonicMean","ContrastiveLossLayer","Control","ControlActive","ControlAlignment","ControlGroupContentsBox","ControllabilityGramian","ControllabilityMatrix","ControllableDecomposition","ControllableModelQ","ControllerDuration","ControllerInformation","ControllerInformationData","ControllerLinking","ControllerManipulate","ControllerMethod","ControllerPath","ControllerState","ControlPlacement","ControlsRendering","ControlType","Convergents","ConversionOptions","ConversionRules","ConvertToBitmapPacket","ConvertToPostScript","ConvertToPostScriptPacket","ConvexHullMesh","ConvexPolygonQ","ConvexPolyhedronQ","ConvolutionLayer","Convolve","ConwayGroupCo1","ConwayGroupCo2","ConwayGroupCo3","CookieFunction","Cookies","CoordinateBoundingBox","CoordinateBoundingBoxArray","CoordinateBounds","CoordinateBoundsArray","CoordinateChartData","CoordinatesToolOptions","CoordinateTransform","CoordinateTransformData","CoprimeQ","Coproduct","CopulaDistribution","Copyable","CopyDatabin","CopyDirectory","CopyFile","CopyTag","CopyToClipboard","CornerFilter","CornerNeighbors","Correlation","CorrelationDistance","CorrelationFunction","CorrelationTest","Cos","Cosh","CoshIntegral","CosineDistance","CosineWindow","CosIntegral","Cot","Coth","Count","CountDistinct","CountDistinctBy","CounterAssignments","CounterBox","CounterBoxOptions","CounterClockwiseContourIntegral","CounterEvaluator","CounterFunction","CounterIncrements","CounterStyle","CounterStyleMenuListing","CountRoots","CountryData","Counts","CountsBy","Covariance","CovarianceEstimatorFunction","CovarianceFunction","CoxianDistribution","CoxIngersollRossProcess","CoxModel","CoxModelFit","CramerVonMisesTest","CreateArchive","CreateCellID","CreateChannel","CreateCloudExpression","CreateDatabin","CreateDataStructure","CreateDataSystemModel","CreateDialog","CreateDirectory","CreateDocument","CreateFile","CreateIntermediateDirectories","CreateManagedLibraryExpression","CreateNotebook","CreatePacletArchive","CreatePalette","CreatePalettePacket","CreatePermissionsGroup","CreateScheduledTask","CreateSearchIndex","CreateSystemModel","CreateTemporary","CreateUUID","CreateWindow","CriterionFunction","CriticalityFailureImportance","CriticalitySuccessImportance","CriticalSection","Cross","CrossEntropyLossLayer","CrossingCount","CrossingDetect","CrossingPolygon","CrossMatrix","Csc","Csch","CTCLossLayer","Cube","CubeRoot","Cubics","Cuboid","CuboidBox","Cumulant","CumulantGeneratingFunction","Cup","CupCap","Curl","CurlyDoubleQuote","CurlyQuote","CurrencyConvert","CurrentDate","CurrentImage","CurrentlySpeakingPacket","CurrentNotebookImage","CurrentScreenImage","CurrentValue","Curry","CurryApplied","CurvatureFlowFilter","CurveClosed","Cyan","CycleGraph","CycleIndexPolynomial","Cycles","CyclicGroup","Cyclotomic","Cylinder","CylinderBox","CylindricalDecomposition","D","DagumDistribution","DamData","DamerauLevenshteinDistance","DampingFactor","Darker","Dashed","Dashing","DatabaseConnect","DatabaseDisconnect","DatabaseReference","Databin","DatabinAdd","DatabinRemove","Databins","DatabinUpload","DataCompression","DataDistribution","DataRange","DataReversed","Dataset","DatasetDisplayPanel","DataStructure","DataStructureQ","Date","DateBounds","Dated","DateDelimiters","DateDifference","DatedUnit","DateFormat","DateFunction","DateHistogram","DateInterval","DateList","DateListLogPlot","DateListPlot","DateListStepPlot","DateObject","DateObjectQ","DateOverlapsQ","DatePattern","DatePlus","DateRange","DateReduction","DateString","DateTicksFormat","DateValue","DateWithinQ","DaubechiesWavelet","DavisDistribution","DawsonF","DayCount","DayCountConvention","DayHemisphere","DaylightQ","DayMatchQ","DayName","DayNightTerminator","DayPlus","DayRange","DayRound","DeBruijnGraph","DeBruijnSequence","Debug","DebugTag","Decapitalize","Decimal","DecimalForm","DeclareKnownSymbols","DeclarePackage","Decompose","DeconvolutionLayer","Decrement","Decrypt","DecryptFile","DedekindEta","DeepSpaceProbeData","Default","DefaultAxesStyle","DefaultBaseStyle","DefaultBoxStyle","DefaultButton","DefaultColor","DefaultControlPlacement","DefaultDuplicateCellStyle","DefaultDuration","DefaultElement","DefaultFaceGridsStyle","DefaultFieldHintStyle","DefaultFont","DefaultFontProperties","DefaultFormatType","DefaultFormatTypeForStyle","DefaultFrameStyle","DefaultFrameTicksStyle","DefaultGridLinesStyle","DefaultInlineFormatType","DefaultInputFormatType","DefaultLabelStyle","DefaultMenuStyle","DefaultNaturalLanguage","DefaultNewCellStyle","DefaultNewInlineCellStyle","DefaultNotebook","DefaultOptions","DefaultOutputFormatType","DefaultPrintPrecision","DefaultStyle","DefaultStyleDefinitions","DefaultTextFormatType","DefaultTextInlineFormatType","DefaultTicksStyle","DefaultTooltipStyle","DefaultValue","DefaultValues","Defer","DefineExternal","DefineInputStreamMethod","DefineOutputStreamMethod","DefineResourceFunction","Definition","Degree","DegreeCentrality","DegreeGraphDistribution","DegreeLexicographic","DegreeReverseLexicographic","DEigensystem","DEigenvalues","Deinitialization","Del","DelaunayMesh","Delayed","Deletable","Delete","DeleteAnomalies","DeleteBorderComponents","DeleteCases","DeleteChannel","DeleteCloudExpression","DeleteContents","DeleteDirectory","DeleteDuplicates","DeleteDuplicatesBy","DeleteFile","DeleteMissing","DeleteObject","DeletePermissionsKey","DeleteSearchIndex","DeleteSmallComponents","DeleteStopwords","DeleteWithContents","DeletionWarning","DelimitedArray","DelimitedSequence","Delimiter","DelimiterFlashTime","DelimiterMatching","Delimiters","DeliveryFunction","Dendrogram","Denominator","DensityGraphics","DensityHistogram","DensityPlot","DensityPlot3D","DependentVariables","Deploy","Deployed","Depth","DepthFirstScan","Derivative","DerivativeFilter","DerivedKey","DescriptorStateSpace","DesignMatrix","DestroyAfterEvaluation","Det","DeviceClose","DeviceConfigure","DeviceExecute","DeviceExecuteAsynchronous","DeviceObject","DeviceOpen","DeviceOpenQ","DeviceRead","DeviceReadBuffer","DeviceReadLatest","DeviceReadList","DeviceReadTimeSeries","Devices","DeviceStreams","DeviceWrite","DeviceWriteBuffer","DGaussianWavelet","DiacriticalPositioning","Diagonal","DiagonalizableMatrixQ","DiagonalMatrix","DiagonalMatrixQ","Dialog","DialogIndent","DialogInput","DialogLevel","DialogNotebook","DialogProlog","DialogReturn","DialogSymbols","Diamond","DiamondMatrix","DiceDissimilarity","DictionaryLookup","DictionaryWordQ","DifferenceDelta","DifferenceOrder","DifferenceQuotient","DifferenceRoot","DifferenceRootReduce","Differences","DifferentialD","DifferentialRoot","DifferentialRootReduce","DifferentiatorFilter","DigitalSignature","DigitBlock","DigitBlockMinimum","DigitCharacter","DigitCount","DigitQ","DihedralAngle","DihedralGroup","Dilation","DimensionalCombinations","DimensionalMeshComponents","DimensionReduce","DimensionReducerFunction","DimensionReduction","Dimensions","DiracComb","DiracDelta","DirectedEdge","DirectedEdges","DirectedGraph","DirectedGraphQ","DirectedInfinity","Direction","Directive","Directory","DirectoryName","DirectoryQ","DirectoryStack","DirichletBeta","DirichletCharacter","DirichletCondition","DirichletConvolve","DirichletDistribution","DirichletEta","DirichletL","DirichletLambda","DirichletTransform","DirichletWindow","DisableConsolePrintPacket","DisableFormatting","DiscreteAsymptotic","DiscreteChirpZTransform","DiscreteConvolve","DiscreteDelta","DiscreteHadamardTransform","DiscreteIndicator","DiscreteLimit","DiscreteLQEstimatorGains","DiscreteLQRegulatorGains","DiscreteLyapunovSolve","DiscreteMarkovProcess","DiscreteMaxLimit","DiscreteMinLimit","DiscretePlot","DiscretePlot3D","DiscreteRatio","DiscreteRiccatiSolve","DiscreteShift","DiscreteTimeModelQ","DiscreteUniformDistribution","DiscreteVariables","DiscreteWaveletData","DiscreteWaveletPacketTransform","DiscreteWaveletTransform","DiscretizeGraphics","DiscretizeRegion","Discriminant","DisjointQ","Disjunction","Disk","DiskBox","DiskMatrix","DiskSegment","Dispatch","DispatchQ","DispersionEstimatorFunction","Display","DisplayAllSteps","DisplayEndPacket","DisplayFlushImagePacket","DisplayForm","DisplayFunction","DisplayPacket","DisplayRules","DisplaySetSizePacket","DisplayString","DisplayTemporary","DisplayWith","DisplayWithRef","DisplayWithVariable","DistanceFunction","DistanceMatrix","DistanceTransform","Distribute","Distributed","DistributedContexts","DistributeDefinitions","DistributionChart","DistributionDomain","DistributionFitTest","DistributionParameterAssumptions","DistributionParameterQ","Dithering","Div","Divergence","Divide","DivideBy","Dividers","DivideSides","Divisible","Divisors","DivisorSigma","DivisorSum","DMSList","DMSString","Do","DockedCells","DocumentGenerator","DocumentGeneratorInformation","DocumentGeneratorInformationData","DocumentGenerators","DocumentNotebook","DocumentWeightingRules","Dodecahedron","DomainRegistrationInformation","DominantColors","DOSTextFormat","Dot","DotDashed","DotEqual","DotLayer","DotPlusLayer","Dotted","DoubleBracketingBar","DoubleContourIntegral","DoubleDownArrow","DoubleLeftArrow","DoubleLeftRightArrow","DoubleLeftTee","DoubleLongLeftArrow","DoubleLongLeftRightArrow","DoubleLongRightArrow","DoubleRightArrow","DoubleRightTee","DoubleUpArrow","DoubleUpDownArrow","DoubleVerticalBar","DoublyInfinite","Down","DownArrow","DownArrowBar","DownArrowUpArrow","DownLeftRightVector","DownLeftTeeVector","DownLeftVector","DownLeftVectorBar","DownRightTeeVector","DownRightVector","DownRightVectorBar","Downsample","DownTee","DownTeeArrow","DownValues","DragAndDrop","DrawEdges","DrawFrontFaces","DrawHighlighted","Drop","DropoutLayer","DSolve","DSolveValue","Dt","DualLinearProgramming","DualPolyhedron","DualSystemsModel","DumpGet","DumpSave","DuplicateFreeQ","Duration","Dynamic","DynamicBox","DynamicBoxOptions","DynamicEvaluationTimeout","DynamicGeoGraphics","DynamicImage","DynamicLocation","DynamicModule","DynamicModuleBox","DynamicModuleBoxOptions","DynamicModuleParent","DynamicModuleValues","DynamicName","DynamicNamespace","DynamicReference","DynamicSetting","DynamicUpdating","DynamicWrapper","DynamicWrapperBox","DynamicWrapperBoxOptions","E","EarthImpactData","EarthquakeData","EccentricityCentrality","Echo","EchoFunction","EclipseType","EdgeAdd","EdgeBetweennessCentrality","EdgeCapacity","EdgeCapForm","EdgeColor","EdgeConnectivity","EdgeContract","EdgeCost","EdgeCount","EdgeCoverQ","EdgeCycleMatrix","EdgeDashing","EdgeDelete","EdgeDetect","EdgeForm","EdgeIndex","EdgeJoinForm","EdgeLabeling","EdgeLabels","EdgeLabelStyle","EdgeList","EdgeOpacity","EdgeQ","EdgeRenderingFunction","EdgeRules","EdgeShapeFunction","EdgeStyle","EdgeTaggedGraph","EdgeTaggedGraphQ","EdgeTags","EdgeThickness","EdgeWeight","EdgeWeightedGraphQ","Editable","EditButtonSettings","EditCellTagsSettings","EditDistance","EffectiveInterest","Eigensystem","Eigenvalues","EigenvectorCentrality","Eigenvectors","Element","ElementData","ElementwiseLayer","ElidedForms","Eliminate","EliminationOrder","Ellipsoid","EllipticE","EllipticExp","EllipticExpPrime","EllipticF","EllipticFilterModel","EllipticK","EllipticLog","EllipticNomeQ","EllipticPi","EllipticReducedHalfPeriods","EllipticTheta","EllipticThetaPrime","EmbedCode","EmbeddedHTML","EmbeddedService","EmbeddingLayer","EmbeddingObject","EmitSound","EmphasizeSyntaxErrors","EmpiricalDistribution","Empty","EmptyGraphQ","EmptyRegion","EnableConsolePrintPacket","Enabled","Encode","Encrypt","EncryptedObject","EncryptFile","End","EndAdd","EndDialogPacket","EndFrontEndInteractionPacket","EndOfBuffer","EndOfFile","EndOfLine","EndOfString","EndPackage","EngineEnvironment","EngineeringForm","Enter","EnterExpressionPacket","EnterTextPacket","Entity","EntityClass","EntityClassList","EntityCopies","EntityFunction","EntityGroup","EntityInstance","EntityList","EntityPrefetch","EntityProperties","EntityProperty","EntityPropertyClass","EntityRegister","EntityStore","EntityStores","EntityTypeName","EntityUnregister","EntityValue","Entropy","EntropyFilter","Environment","Epilog","EpilogFunction","Equal","EqualColumns","EqualRows","EqualTilde","EqualTo","EquatedTo","Equilibrium","EquirippleFilterKernel","Equivalent","Erf","Erfc","Erfi","ErlangB","ErlangC","ErlangDistribution","Erosion","ErrorBox","ErrorBoxOptions","ErrorNorm","ErrorPacket","ErrorsDialogSettings","EscapeRadius","EstimatedBackground","EstimatedDistribution","EstimatedProcess","EstimatorGains","EstimatorRegulator","EuclideanDistance","EulerAngles","EulerCharacteristic","EulerE","EulerGamma","EulerianGraphQ","EulerMatrix","EulerPhi","Evaluatable","Evaluate","Evaluated","EvaluatePacket","EvaluateScheduledTask","EvaluationBox","EvaluationCell","EvaluationCompletionAction","EvaluationData","EvaluationElements","EvaluationEnvironment","EvaluationMode","EvaluationMonitor","EvaluationNotebook","EvaluationObject","EvaluationOrder","Evaluator","EvaluatorNames","EvenQ","EventData","EventEvaluator","EventHandler","EventHandlerTag","EventLabels","EventSeries","ExactBlackmanWindow","ExactNumberQ","ExactRootIsolation","ExampleData","Except","ExcludedForms","ExcludedLines","ExcludedPhysicalQuantities","ExcludePods","Exclusions","ExclusionsStyle","Exists","Exit","ExitDialog","ExoplanetData","Exp","Expand","ExpandAll","ExpandDenominator","ExpandFileName","ExpandNumerator","Expectation","ExpectationE","ExpectedValue","ExpGammaDistribution","ExpIntegralE","ExpIntegralEi","ExpirationDate","Exponent","ExponentFunction","ExponentialDistribution","ExponentialFamily","ExponentialGeneratingFunction","ExponentialMovingAverage","ExponentialPowerDistribution","ExponentPosition","ExponentStep","Export","ExportAutoReplacements","ExportByteArray","ExportForm","ExportPacket","ExportString","Expression","ExpressionCell","ExpressionGraph","ExpressionPacket","ExpressionUUID","ExpToTrig","ExtendedEntityClass","ExtendedGCD","Extension","ExtentElementFunction","ExtentMarkers","ExtentSize","ExternalBundle","ExternalCall","ExternalDataCharacterEncoding","ExternalEvaluate","ExternalFunction","ExternalFunctionName","ExternalIdentifier","ExternalObject","ExternalOptions","ExternalSessionObject","ExternalSessions","ExternalStorageBase","ExternalStorageDownload","ExternalStorageGet","ExternalStorageObject","ExternalStoragePut","ExternalStorageUpload","ExternalTypeSignature","ExternalValue","Extract","ExtractArchive","ExtractLayer","ExtractPacletArchive","ExtremeValueDistribution","FaceAlign","FaceForm","FaceGrids","FaceGridsStyle","FacialFeatures","Factor","FactorComplete","Factorial","Factorial2","FactorialMoment","FactorialMomentGeneratingFunction","FactorialPower","FactorInteger","FactorList","FactorSquareFree","FactorSquareFreeList","FactorTerms","FactorTermsList","Fail","Failure","FailureAction","FailureDistribution","FailureQ","False","FareySequence","FARIMAProcess","FeatureDistance","FeatureExtract","FeatureExtraction","FeatureExtractor","FeatureExtractorFunction","FeatureNames","FeatureNearest","FeatureSpacePlot","FeatureSpacePlot3D","FeatureTypes","FEDisableConsolePrintPacket","FeedbackLinearize","FeedbackSector","FeedbackSectorStyle","FeedbackType","FEEnableConsolePrintPacket","FetalGrowthData","Fibonacci","Fibonorial","FieldCompletionFunction","FieldHint","FieldHintStyle","FieldMasked","FieldSize","File","FileBaseName","FileByteCount","FileConvert","FileDate","FileExistsQ","FileExtension","FileFormat","FileHandler","FileHash","FileInformation","FileName","FileNameDepth","FileNameDialogSettings","FileNameDrop","FileNameForms","FileNameJoin","FileNames","FileNameSetter","FileNameSplit","FileNameTake","FilePrint","FileSize","FileSystemMap","FileSystemScan","FileTemplate","FileTemplateApply","FileType","FilledCurve","FilledCurveBox","FilledCurveBoxOptions","Filling","FillingStyle","FillingTransform","FilteredEntityClass","FilterRules","FinancialBond","FinancialData","FinancialDerivative","FinancialIndicator","Find","FindAnomalies","FindArgMax","FindArgMin","FindChannels","FindClique","FindClusters","FindCookies","FindCurvePath","FindCycle","FindDevices","FindDistribution","FindDistributionParameters","FindDivisions","FindEdgeCover","FindEdgeCut","FindEdgeIndependentPaths","FindEquationalProof","FindEulerianCycle","FindExternalEvaluators","FindFaces","FindFile","FindFit","FindFormula","FindFundamentalCycles","FindGeneratingFunction","FindGeoLocation","FindGeometricConjectures","FindGeometricTransform","FindGraphCommunities","FindGraphIsomorphism","FindGraphPartition","FindHamiltonianCycle","FindHamiltonianPath","FindHiddenMarkovStates","FindImageText","FindIndependentEdgeSet","FindIndependentVertexSet","FindInstance","FindIntegerNullVector","FindKClan","FindKClique","FindKClub","FindKPlex","FindLibrary","FindLinearRecurrence","FindList","FindMatchingColor","FindMaximum","FindMaximumCut","FindMaximumFlow","FindMaxValue","FindMeshDefects","FindMinimum","FindMinimumCostFlow","FindMinimumCut","FindMinValue","FindMoleculeSubstructure","FindPath","FindPeaks","FindPermutation","FindPostmanTour","FindProcessParameters","FindRepeat","FindRoot","FindSequenceFunction","FindSettings","FindShortestPath","FindShortestTour","FindSpanningTree","FindSystemModelEquilibrium","FindTextualAnswer","FindThreshold","FindTransientRepeat","FindVertexCover","FindVertexCut","FindVertexIndependentPaths","Fine","FinishDynamic","FiniteAbelianGroupCount","FiniteGroupCount","FiniteGroupData","First","FirstCase","FirstPassageTimeDistribution","FirstPosition","FischerGroupFi22","FischerGroupFi23","FischerGroupFi24Prime","FisherHypergeometricDistribution","FisherRatioTest","FisherZDistribution","Fit","FitAll","FitRegularization","FittedModel","FixedOrder","FixedPoint","FixedPointList","FlashSelection","Flat","Flatten","FlattenAt","FlattenLayer","FlatTopWindow","FlipView","Floor","FlowPolynomial","FlushPrintOutputPacket","Fold","FoldList","FoldPair","FoldPairList","FollowRedirects","Font","FontColor","FontFamily","FontForm","FontName","FontOpacity","FontPostScriptName","FontProperties","FontReencoding","FontSize","FontSlant","FontSubstitutions","FontTracking","FontVariations","FontWeight","For","ForAll","ForceVersionInstall","Format","FormatRules","FormatType","FormatTypeAutoConvert","FormatValues","FormBox","FormBoxOptions","FormControl","FormFunction","FormLayoutFunction","FormObject","FormPage","FormTheme","FormulaData","FormulaLookup","FortranForm","Forward","ForwardBackward","Fourier","FourierCoefficient","FourierCosCoefficient","FourierCosSeries","FourierCosTransform","FourierDCT","FourierDCTFilter","FourierDCTMatrix","FourierDST","FourierDSTMatrix","FourierMatrix","FourierParameters","FourierSequenceTransform","FourierSeries","FourierSinCoefficient","FourierSinSeries","FourierSinTransform","FourierTransform","FourierTrigSeries","FractionalBrownianMotionProcess","FractionalGaussianNoiseProcess","FractionalPart","FractionBox","FractionBoxOptions","FractionLine","Frame","FrameBox","FrameBoxOptions","Framed","FrameInset","FrameLabel","Frameless","FrameMargins","FrameRate","FrameStyle","FrameTicks","FrameTicksStyle","FRatioDistribution","FrechetDistribution","FreeQ","FrenetSerretSystem","FrequencySamplingFilterKernel","FresnelC","FresnelF","FresnelG","FresnelS","Friday","FrobeniusNumber","FrobeniusSolve","FromAbsoluteTime","FromCharacterCode","FromCoefficientRules","FromContinuedFraction","FromDate","FromDigits","FromDMS","FromEntity","FromJulianDate","FromLetterNumber","FromPolarCoordinates","FromRomanNumeral","FromSphericalCoordinates","FromUnixTime","Front","FrontEndDynamicExpression","FrontEndEventActions","FrontEndExecute","FrontEndObject","FrontEndResource","FrontEndResourceString","FrontEndStackSize","FrontEndToken","FrontEndTokenExecute","FrontEndValueCache","FrontEndVersion","FrontFaceColor","FrontFaceOpacity","Full","FullAxes","FullDefinition","FullForm","FullGraphics","FullInformationOutputRegulator","FullOptions","FullRegion","FullSimplify","Function","FunctionCompile","FunctionCompileExport","FunctionCompileExportByteArray","FunctionCompileExportLibrary","FunctionCompileExportString","FunctionDomain","FunctionExpand","FunctionInterpolation","FunctionPeriod","FunctionRange","FunctionSpace","FussellVeselyImportance","GaborFilter","GaborMatrix","GaborWavelet","GainMargins","GainPhaseMargins","GalaxyData","GalleryView","Gamma","GammaDistribution","GammaRegularized","GapPenalty","GARCHProcess","GatedRecurrentLayer","Gather","GatherBy","GaugeFaceElementFunction","GaugeFaceStyle","GaugeFrameElementFunction","GaugeFrameSize","GaugeFrameStyle","GaugeLabels","GaugeMarkers","GaugeStyle","GaussianFilter","GaussianIntegers","GaussianMatrix","GaussianOrthogonalMatrixDistribution","GaussianSymplecticMatrixDistribution","GaussianUnitaryMatrixDistribution","GaussianWindow","GCD","GegenbauerC","General","GeneralizedLinearModelFit","GenerateAsymmetricKeyPair","GenerateConditions","GeneratedCell","GeneratedDocumentBinding","GenerateDerivedKey","GenerateDigitalSignature","GenerateDocument","GeneratedParameters","GeneratedQuantityMagnitudes","GenerateFileSignature","GenerateHTTPResponse","GenerateSecuredAuthenticationKey","GenerateSymmetricKey","GeneratingFunction","GeneratorDescription","GeneratorHistoryLength","GeneratorOutputType","Generic","GenericCylindricalDecomposition","GenomeData","GenomeLookup","GeoAntipode","GeoArea","GeoArraySize","GeoBackground","GeoBoundingBox","GeoBounds","GeoBoundsRegion","GeoBubbleChart","GeoCenter","GeoCircle","GeoContourPlot","GeoDensityPlot","GeodesicClosing","GeodesicDilation","GeodesicErosion","GeodesicOpening","GeoDestination","GeodesyData","GeoDirection","GeoDisk","GeoDisplacement","GeoDistance","GeoDistanceList","GeoElevationData","GeoEntities","GeoGraphics","GeogravityModelData","GeoGridDirectionDifference","GeoGridLines","GeoGridLinesStyle","GeoGridPosition","GeoGridRange","GeoGridRangePadding","GeoGridUnitArea","GeoGridUnitDistance","GeoGridVector","GeoGroup","GeoHemisphere","GeoHemisphereBoundary","GeoHistogram","GeoIdentify","GeoImage","GeoLabels","GeoLength","GeoListPlot","GeoLocation","GeologicalPeriodData","GeomagneticModelData","GeoMarker","GeometricAssertion","GeometricBrownianMotionProcess","GeometricDistribution","GeometricMean","GeometricMeanFilter","GeometricOptimization","GeometricScene","GeometricTransformation","GeometricTransformation3DBox","GeometricTransformation3DBoxOptions","GeometricTransformationBox","GeometricTransformationBoxOptions","GeoModel","GeoNearest","GeoPath","GeoPosition","GeoPositionENU","GeoPositionXYZ","GeoProjection","GeoProjectionData","GeoRange","GeoRangePadding","GeoRegionValuePlot","GeoResolution","GeoScaleBar","GeoServer","GeoSmoothHistogram","GeoStreamPlot","GeoStyling","GeoStylingImageFunction","GeoVariant","GeoVector","GeoVectorENU","GeoVectorPlot","GeoVectorXYZ","GeoVisibleRegion","GeoVisibleRegionBoundary","GeoWithinQ","GeoZoomLevel","GestureHandler","GestureHandlerTag","Get","GetBoundingBoxSizePacket","GetContext","GetEnvironment","GetFileName","GetFrontEndOptionsDataPacket","GetLinebreakInformationPacket","GetMenusPacket","GetPageBreakInformationPacket","Glaisher","GlobalClusteringCoefficient","GlobalPreferences","GlobalSession","Glow","GoldenAngle","GoldenRatio","GompertzMakehamDistribution","GoochShading","GoodmanKruskalGamma","GoodmanKruskalGammaTest","Goto","Grad","Gradient","GradientFilter","GradientOrientationFilter","GrammarApply","GrammarRules","GrammarToken","Graph","Graph3D","GraphAssortativity","GraphAutomorphismGroup","GraphCenter","GraphComplement","GraphData","GraphDensity","GraphDiameter","GraphDifference","GraphDisjointUnion","GraphDistance","GraphDistanceMatrix","GraphElementData","GraphEmbedding","GraphHighlight","GraphHighlightStyle","GraphHub","Graphics","Graphics3D","Graphics3DBox","Graphics3DBoxOptions","GraphicsArray","GraphicsBaseline","GraphicsBox","GraphicsBoxOptions","GraphicsColor","GraphicsColumn","GraphicsComplex","GraphicsComplex3DBox","GraphicsComplex3DBoxOptions","GraphicsComplexBox","GraphicsComplexBoxOptions","GraphicsContents","GraphicsData","GraphicsGrid","GraphicsGridBox","GraphicsGroup","GraphicsGroup3DBox","GraphicsGroup3DBoxOptions","GraphicsGroupBox","GraphicsGroupBoxOptions","GraphicsGrouping","GraphicsHighlightColor","GraphicsRow","GraphicsSpacing","GraphicsStyle","GraphIntersection","GraphLayout","GraphLinkEfficiency","GraphPeriphery","GraphPlot","GraphPlot3D","GraphPower","GraphPropertyDistribution","GraphQ","GraphRadius","GraphReciprocity","GraphRoot","GraphStyle","GraphUnion","Gray","GrayLevel","Greater","GreaterEqual","GreaterEqualLess","GreaterEqualThan","GreaterFullEqual","GreaterGreater","GreaterLess","GreaterSlantEqual","GreaterThan","GreaterTilde","Green","GreenFunction","Grid","GridBaseline","GridBox","GridBoxAlignment","GridBoxBackground","GridBoxDividers","GridBoxFrame","GridBoxItemSize","GridBoxItemStyle","GridBoxOptions","GridBoxSpacings","GridCreationSettings","GridDefaultElement","GridElementStyleOptions","GridFrame","GridFrameMargins","GridGraph","GridLines","GridLinesStyle","GroebnerBasis","GroupActionBase","GroupBy","GroupCentralizer","GroupElementFromWord","GroupElementPosition","GroupElementQ","GroupElements","GroupElementToWord","GroupGenerators","Groupings","GroupMultiplicationTable","GroupOrbits","GroupOrder","GroupPageBreakWithin","GroupSetwiseStabilizer","GroupStabilizer","GroupStabilizerChain","GroupTogetherGrouping","GroupTogetherNestedGrouping","GrowCutComponents","Gudermannian","GuidedFilter","GumbelDistribution","HaarWavelet","HadamardMatrix","HalfLine","HalfNormalDistribution","HalfPlane","HalfSpace","HalftoneShading","HamiltonianGraphQ","HammingDistance","HammingWindow","HandlerFunctions","HandlerFunctionsKeys","HankelH1","HankelH2","HankelMatrix","HankelTransform","HannPoissonWindow","HannWindow","HaradaNortonGroupHN","HararyGraph","HarmonicMean","HarmonicMeanFilter","HarmonicNumber","Hash","HatchFilling","HatchShading","Haversine","HazardFunction","Head","HeadCompose","HeaderAlignment","HeaderBackground","HeaderDisplayFunction","HeaderLines","HeaderSize","HeaderStyle","Heads","HeavisideLambda","HeavisidePi","HeavisideTheta","HeldGroupHe","HeldPart","HelpBrowserLookup","HelpBrowserNotebook","HelpBrowserSettings","Here","HermiteDecomposition","HermiteH","HermitianMatrixQ","HessenbergDecomposition","Hessian","HeunB","HeunBPrime","HeunC","HeunCPrime","HeunD","HeunDPrime","HeunG","HeunGPrime","HeunT","HeunTPrime","HexadecimalCharacter","Hexahedron","HexahedronBox","HexahedronBoxOptions","HiddenItems","HiddenMarkovProcess","HiddenSurface","Highlighted","HighlightGraph","HighlightImage","HighlightMesh","HighpassFilter","HigmanSimsGroupHS","HilbertCurve","HilbertFilter","HilbertMatrix","Histogram","Histogram3D","HistogramDistribution","HistogramList","HistogramTransform","HistogramTransformInterpolation","HistoricalPeriodData","HitMissTransform","HITSCentrality","HjorthDistribution","HodgeDual","HoeffdingD","HoeffdingDTest","Hold","HoldAll","HoldAllComplete","HoldComplete","HoldFirst","HoldForm","HoldPattern","HoldRest","HolidayCalendar","HomeDirectory","HomePage","Horizontal","HorizontalForm","HorizontalGauge","HorizontalScrollPosition","HornerForm","HostLookup","HotellingTSquareDistribution","HoytDistribution","HTMLSave","HTTPErrorResponse","HTTPRedirect","HTTPRequest","HTTPRequestData","HTTPResponse","Hue","HumanGrowthData","HumpDownHump","HumpEqual","HurwitzLerchPhi","HurwitzZeta","HyperbolicDistribution","HypercubeGraph","HyperexponentialDistribution","Hyperfactorial","Hypergeometric0F1","Hypergeometric0F1Regularized","Hypergeometric1F1","Hypergeometric1F1Regularized","Hypergeometric2F1","Hypergeometric2F1Regularized","HypergeometricDistribution","HypergeometricPFQ","HypergeometricPFQRegularized","HypergeometricU","Hyperlink","HyperlinkAction","HyperlinkCreationSettings","Hyperplane","Hyphenation","HyphenationOptions","HypoexponentialDistribution","HypothesisTestData","I","IconData","Iconize","IconizedObject","IconRules","Icosahedron","Identity","IdentityMatrix","If","IgnoreCase","IgnoreDiacritics","IgnorePunctuation","IgnoreSpellCheck","IgnoringInactive","Im","Image","Image3D","Image3DProjection","Image3DSlices","ImageAccumulate","ImageAdd","ImageAdjust","ImageAlign","ImageApply","ImageApplyIndexed","ImageAspectRatio","ImageAssemble","ImageAugmentationLayer","ImageBoundingBoxes","ImageCache","ImageCacheValid","ImageCapture","ImageCaptureFunction","ImageCases","ImageChannels","ImageClip","ImageCollage","ImageColorSpace","ImageCompose","ImageContainsQ","ImageContents","ImageConvolve","ImageCooccurrence","ImageCorners","ImageCorrelate","ImageCorrespondingPoints","ImageCrop","ImageData","ImageDeconvolve","ImageDemosaic","ImageDifference","ImageDimensions","ImageDisplacements","ImageDistance","ImageEffect","ImageExposureCombine","ImageFeatureTrack","ImageFileApply","ImageFileFilter","ImageFileScan","ImageFilter","ImageFocusCombine","ImageForestingComponents","ImageFormattingWidth","ImageForwardTransformation","ImageGraphics","ImageHistogram","ImageIdentify","ImageInstanceQ","ImageKeypoints","ImageLabels","ImageLegends","ImageLevels","ImageLines","ImageMargins","ImageMarker","ImageMarkers","ImageMeasurements","ImageMesh","ImageMultiply","ImageOffset","ImagePad","ImagePadding","ImagePartition","ImagePeriodogram","ImagePerspectiveTransformation","ImagePosition","ImagePreviewFunction","ImagePyramid","ImagePyramidApply","ImageQ","ImageRangeCache","ImageRecolor","ImageReflect","ImageRegion","ImageResize","ImageResolution","ImageRestyle","ImageRotate","ImageRotated","ImageSaliencyFilter","ImageScaled","ImageScan","ImageSize","ImageSizeAction","ImageSizeCache","ImageSizeMultipliers","ImageSizeRaw","ImageSubtract","ImageTake","ImageTransformation","ImageTrim","ImageType","ImageValue","ImageValuePositions","ImagingDevice","ImplicitRegion","Implies","Import","ImportAutoReplacements","ImportByteArray","ImportOptions","ImportString","ImprovementImportance","In","Inactivate","Inactive","IncidenceGraph","IncidenceList","IncidenceMatrix","IncludeAromaticBonds","IncludeConstantBasis","IncludeDefinitions","IncludeDirectories","IncludeFileExtension","IncludeGeneratorTasks","IncludeHydrogens","IncludeInflections","IncludeMetaInformation","IncludePods","IncludeQuantities","IncludeRelatedTables","IncludeSingularTerm","IncludeWindowTimes","Increment","IndefiniteMatrixQ","Indent","IndentingNewlineSpacings","IndentMaxFraction","IndependenceTest","IndependentEdgeSetQ","IndependentPhysicalQuantity","IndependentUnit","IndependentUnitDimension","IndependentVertexSetQ","Indeterminate","IndeterminateThreshold","IndexCreationOptions","Indexed","IndexEdgeTaggedGraph","IndexGraph","IndexTag","Inequality","InexactNumberQ","InexactNumbers","InfiniteFuture","InfiniteLine","InfinitePast","InfinitePlane","Infinity","Infix","InflationAdjust","InflationMethod","Information","InformationData","InformationDataGrid","Inherited","InheritScope","InhomogeneousPoissonProcess","InitialEvaluationHistory","Initialization","InitializationCell","InitializationCellEvaluation","InitializationCellWarning","InitializationObjects","InitializationValue","Initialize","InitialSeeding","InlineCounterAssignments","InlineCounterIncrements","InlineRules","Inner","InnerPolygon","InnerPolyhedron","Inpaint","Input","InputAliases","InputAssumptions","InputAutoReplacements","InputField","InputFieldBox","InputFieldBoxOptions","InputForm","InputGrouping","InputNamePacket","InputNotebook","InputPacket","InputSettings","InputStream","InputString","InputStringPacket","InputToBoxFormPacket","Insert","InsertionFunction","InsertionPointObject","InsertLinebreaks","InsertResults","Inset","Inset3DBox","Inset3DBoxOptions","InsetBox","InsetBoxOptions","Insphere","Install","InstallService","InstanceNormalizationLayer","InString","Integer","IntegerDigits","IntegerExponent","IntegerLength","IntegerName","IntegerPart","IntegerPartitions","IntegerQ","IntegerReverse","Integers","IntegerString","Integral","Integrate","Interactive","InteractiveTradingChart","Interlaced","Interleaving","InternallyBalancedDecomposition","InterpolatingFunction","InterpolatingPolynomial","Interpolation","InterpolationOrder","InterpolationPoints","InterpolationPrecision","Interpretation","InterpretationBox","InterpretationBoxOptions","InterpretationFunction","Interpreter","InterpretTemplate","InterquartileRange","Interrupt","InterruptSettings","IntersectedEntityClass","IntersectingQ","Intersection","Interval","IntervalIntersection","IntervalMarkers","IntervalMarkersStyle","IntervalMemberQ","IntervalSlider","IntervalUnion","Into","Inverse","InverseBetaRegularized","InverseCDF","InverseChiSquareDistribution","InverseContinuousWaveletTransform","InverseDistanceTransform","InverseEllipticNomeQ","InverseErf","InverseErfc","InverseFourier","InverseFourierCosTransform","InverseFourierSequenceTransform","InverseFourierSinTransform","InverseFourierTransform","InverseFunction","InverseFunctions","InverseGammaDistribution","InverseGammaRegularized","InverseGaussianDistribution","InverseGudermannian","InverseHankelTransform","InverseHaversine","InverseImagePyramid","InverseJacobiCD","InverseJacobiCN","InverseJacobiCS","InverseJacobiDC","InverseJacobiDN","InverseJacobiDS","InverseJacobiNC","InverseJacobiND","InverseJacobiNS","InverseJacobiSC","InverseJacobiSD","InverseJacobiSN","InverseLaplaceTransform","InverseMellinTransform","InversePermutation","InverseRadon","InverseRadonTransform","InverseSeries","InverseShortTimeFourier","InverseSpectrogram","InverseSurvivalFunction","InverseTransformedRegion","InverseWaveletTransform","InverseWeierstrassP","InverseWishartMatrixDistribution","InverseZTransform","Invisible","InvisibleApplication","InvisibleTimes","IPAddress","IrreduciblePolynomialQ","IslandData","IsolatingInterval","IsomorphicGraphQ","IsotopeData","Italic","Item","ItemAspectRatio","ItemBox","ItemBoxOptions","ItemDisplayFunction","ItemSize","ItemStyle","ItoProcess","JaccardDissimilarity","JacobiAmplitude","Jacobian","JacobiCD","JacobiCN","JacobiCS","JacobiDC","JacobiDN","JacobiDS","JacobiNC","JacobiND","JacobiNS","JacobiP","JacobiSC","JacobiSD","JacobiSN","JacobiSymbol","JacobiZeta","JankoGroupJ1","JankoGroupJ2","JankoGroupJ3","JankoGroupJ4","JarqueBeraALMTest","JohnsonDistribution","Join","JoinAcross","Joined","JoinedCurve","JoinedCurveBox","JoinedCurveBoxOptions","JoinForm","JordanDecomposition","JordanModelDecomposition","JulianDate","JuliaSetBoettcher","JuliaSetIterationCount","JuliaSetPlot","JuliaSetPoints","K","KagiChart","KaiserBesselWindow","KaiserWindow","KalmanEstimator","KalmanFilter","KarhunenLoeveDecomposition","KaryTree","KatzCentrality","KCoreComponents","KDistribution","KEdgeConnectedComponents","KEdgeConnectedGraphQ","KeepExistingVersion","KelvinBei","KelvinBer","KelvinKei","KelvinKer","KendallTau","KendallTauTest","KernelExecute","KernelFunction","KernelMixtureDistribution","KernelObject","Kernels","Ket","Key","KeyCollisionFunction","KeyComplement","KeyDrop","KeyDropFrom","KeyExistsQ","KeyFreeQ","KeyIntersection","KeyMap","KeyMemberQ","KeypointStrength","Keys","KeySelect","KeySort","KeySortBy","KeyTake","KeyUnion","KeyValueMap","KeyValuePattern","Khinchin","KillProcess","KirchhoffGraph","KirchhoffMatrix","KleinInvariantJ","KnapsackSolve","KnightTourGraph","KnotData","KnownUnitQ","KochCurve","KolmogorovSmirnovTest","KroneckerDelta","KroneckerModelDecomposition","KroneckerProduct","KroneckerSymbol","KuiperTest","KumaraswamyDistribution","Kurtosis","KuwaharaFilter","KVertexConnectedComponents","KVertexConnectedGraphQ","LABColor","Label","Labeled","LabeledSlider","LabelingFunction","LabelingSize","LabelStyle","LabelVisibility","LaguerreL","LakeData","LambdaComponents","LambertW","LaminaData","LanczosWindow","LandauDistribution","Language","LanguageCategory","LanguageData","LanguageIdentify","LanguageOptions","LaplaceDistribution","LaplaceTransform","Laplacian","LaplacianFilter","LaplacianGaussianFilter","Large","Larger","Last","Latitude","LatitudeLongitude","LatticeData","LatticeReduce","Launch","LaunchKernels","LayeredGraphPlot","LayerSizeFunction","LayoutInformation","LCHColor","LCM","LeaderSize","LeafCount","LeapYearQ","LearnDistribution","LearnedDistribution","LearningRate","LearningRateMultipliers","LeastSquares","LeastSquaresFilterKernel","Left","LeftArrow","LeftArrowBar","LeftArrowRightArrow","LeftDownTeeVector","LeftDownVector","LeftDownVectorBar","LeftRightArrow","LeftRightVector","LeftTee","LeftTeeArrow","LeftTeeVector","LeftTriangle","LeftTriangleBar","LeftTriangleEqual","LeftUpDownVector","LeftUpTeeVector","LeftUpVector","LeftUpVectorBar","LeftVector","LeftVectorBar","LegendAppearance","Legended","LegendFunction","LegendLabel","LegendLayout","LegendMargins","LegendMarkers","LegendMarkerSize","LegendreP","LegendreQ","LegendreType","Length","LengthWhile","LerchPhi","Less","LessEqual","LessEqualGreater","LessEqualThan","LessFullEqual","LessGreater","LessLess","LessSlantEqual","LessThan","LessTilde","LetterCharacter","LetterCounts","LetterNumber","LetterQ","Level","LeveneTest","LeviCivitaTensor","LevyDistribution","Lexicographic","LibraryDataType","LibraryFunction","LibraryFunctionError","LibraryFunctionInformation","LibraryFunctionLoad","LibraryFunctionUnload","LibraryLoad","LibraryUnload","LicenseID","LiftingFilterData","LiftingWaveletTransform","LightBlue","LightBrown","LightCyan","Lighter","LightGray","LightGreen","Lighting","LightingAngle","LightMagenta","LightOrange","LightPink","LightPurple","LightRed","LightSources","LightYellow","Likelihood","Limit","LimitsPositioning","LimitsPositioningTokens","LindleyDistribution","Line","Line3DBox","Line3DBoxOptions","LinearFilter","LinearFractionalOptimization","LinearFractionalTransform","LinearGradientImage","LinearizingTransformationData","LinearLayer","LinearModelFit","LinearOffsetFunction","LinearOptimization","LinearProgramming","LinearRecurrence","LinearSolve","LinearSolveFunction","LineBox","LineBoxOptions","LineBreak","LinebreakAdjustments","LineBreakChart","LinebreakSemicolonWeighting","LineBreakWithin","LineColor","LineGraph","LineIndent","LineIndentMaxFraction","LineIntegralConvolutionPlot","LineIntegralConvolutionScale","LineLegend","LineOpacity","LineSpacing","LineWrapParts","LinkActivate","LinkClose","LinkConnect","LinkConnectedQ","LinkCreate","LinkError","LinkFlush","LinkFunction","LinkHost","LinkInterrupt","LinkLaunch","LinkMode","LinkObject","LinkOpen","LinkOptions","LinkPatterns","LinkProtocol","LinkRankCentrality","LinkRead","LinkReadHeld","LinkReadyQ","Links","LinkService","LinkWrite","LinkWriteHeld","LiouvilleLambda","List","Listable","ListAnimate","ListContourPlot","ListContourPlot3D","ListConvolve","ListCorrelate","ListCurvePathPlot","ListDeconvolve","ListDensityPlot","ListDensityPlot3D","Listen","ListFormat","ListFourierSequenceTransform","ListInterpolation","ListLineIntegralConvolutionPlot","ListLinePlot","ListLogLinearPlot","ListLogLogPlot","ListLogPlot","ListPicker","ListPickerBox","ListPickerBoxBackground","ListPickerBoxOptions","ListPlay","ListPlot","ListPlot3D","ListPointPlot3D","ListPolarPlot","ListQ","ListSliceContourPlot3D","ListSliceDensityPlot3D","ListSliceVectorPlot3D","ListStepPlot","ListStreamDensityPlot","ListStreamPlot","ListSurfacePlot3D","ListVectorDensityPlot","ListVectorPlot","ListVectorPlot3D","ListZTransform","Literal","LiteralSearch","LocalAdaptiveBinarize","LocalCache","LocalClusteringCoefficient","LocalizeDefinitions","LocalizeVariables","LocalObject","LocalObjects","LocalResponseNormalizationLayer","LocalSubmit","LocalSymbol","LocalTime","LocalTimeZone","LocationEquivalenceTest","LocationTest","Locator","LocatorAutoCreate","LocatorBox","LocatorBoxOptions","LocatorCentering","LocatorPane","LocatorPaneBox","LocatorPaneBoxOptions","LocatorRegion","Locked","Log","Log10","Log2","LogBarnesG","LogGamma","LogGammaDistribution","LogicalExpand","LogIntegral","LogisticDistribution","LogisticSigmoid","LogitModelFit","LogLikelihood","LogLinearPlot","LogLogisticDistribution","LogLogPlot","LogMultinormalDistribution","LogNormalDistribution","LogPlot","LogRankTest","LogSeriesDistribution","LongEqual","Longest","LongestCommonSequence","LongestCommonSequencePositions","LongestCommonSubsequence","LongestCommonSubsequencePositions","LongestMatch","LongestOrderedSequence","LongForm","Longitude","LongLeftArrow","LongLeftRightArrow","LongRightArrow","LongShortTermMemoryLayer","Lookup","Loopback","LoopFreeGraphQ","Looping","LossFunction","LowerCaseQ","LowerLeftArrow","LowerRightArrow","LowerTriangularize","LowerTriangularMatrixQ","LowpassFilter","LQEstimatorGains","LQGRegulator","LQOutputRegulatorGains","LQRegulatorGains","LUBackSubstitution","LucasL","LuccioSamiComponents","LUDecomposition","LunarEclipse","LUVColor","LyapunovSolve","LyonsGroupLy","MachineID","MachineName","MachineNumberQ","MachinePrecision","MacintoshSystemPageSetup","Magenta","Magnification","Magnify","MailAddressValidation","MailExecute","MailFolder","MailItem","MailReceiverFunction","MailResponseFunction","MailSearch","MailServerConnect","MailServerConnection","MailSettings","MainSolve","MaintainDynamicCaches","Majority","MakeBoxes","MakeExpression","MakeRules","ManagedLibraryExpressionID","ManagedLibraryExpressionQ","MandelbrotSetBoettcher","MandelbrotSetDistance","MandelbrotSetIterationCount","MandelbrotSetMemberQ","MandelbrotSetPlot","MangoldtLambda","ManhattanDistance","Manipulate","Manipulator","MannedSpaceMissionData","MannWhitneyTest","MantissaExponent","Manual","Map","MapAll","MapAt","MapIndexed","MAProcess","MapThread","MarchenkoPasturDistribution","MarcumQ","MardiaCombinedTest","MardiaKurtosisTest","MardiaSkewnessTest","MarginalDistribution","MarkovProcessProperties","Masking","MatchingDissimilarity","MatchLocalNameQ","MatchLocalNames","MatchQ","Material","MathematicalFunctionData","MathematicaNotation","MathieuC","MathieuCharacteristicA","MathieuCharacteristicB","MathieuCharacteristicExponent","MathieuCPrime","MathieuGroupM11","MathieuGroupM12","MathieuGroupM22","MathieuGroupM23","MathieuGroupM24","MathieuS","MathieuSPrime","MathMLForm","MathMLText","Matrices","MatrixExp","MatrixForm","MatrixFunction","MatrixLog","MatrixNormalDistribution","MatrixPlot","MatrixPower","MatrixPropertyDistribution","MatrixQ","MatrixRank","MatrixTDistribution","Max","MaxBend","MaxCellMeasure","MaxColorDistance","MaxDate","MaxDetect","MaxDuration","MaxExtraBandwidths","MaxExtraConditions","MaxFeatureDisplacement","MaxFeatures","MaxFilter","MaximalBy","Maximize","MaxItems","MaxIterations","MaxLimit","MaxMemoryUsed","MaxMixtureKernels","MaxOverlapFraction","MaxPlotPoints","MaxPoints","MaxRecursion","MaxStableDistribution","MaxStepFraction","MaxSteps","MaxStepSize","MaxTrainingRounds","MaxValue","MaxwellDistribution","MaxWordGap","McLaughlinGroupMcL","Mean","MeanAbsoluteLossLayer","MeanAround","MeanClusteringCoefficient","MeanDegreeConnectivity","MeanDeviation","MeanFilter","MeanGraphDistance","MeanNeighborDegree","MeanShift","MeanShiftFilter","MeanSquaredLossLayer","Median","MedianDeviation","MedianFilter","MedicalTestData","Medium","MeijerG","MeijerGReduce","MeixnerDistribution","MellinConvolve","MellinTransform","MemberQ","MemoryAvailable","MemoryConstrained","MemoryConstraint","MemoryInUse","MengerMesh","Menu","MenuAppearance","MenuCommandKey","MenuEvaluator","MenuItem","MenuList","MenuPacket","MenuSortingValue","MenuStyle","MenuView","Merge","MergeDifferences","MergingFunction","MersennePrimeExponent","MersennePrimeExponentQ","Mesh","MeshCellCentroid","MeshCellCount","MeshCellHighlight","MeshCellIndex","MeshCellLabel","MeshCellMarker","MeshCellMeasure","MeshCellQuality","MeshCells","MeshCellShapeFunction","MeshCellStyle","MeshConnectivityGraph","MeshCoordinates","MeshFunctions","MeshPrimitives","MeshQualityGoal","MeshRange","MeshRefinementFunction","MeshRegion","MeshRegionQ","MeshShading","MeshStyle","Message","MessageDialog","MessageList","MessageName","MessageObject","MessageOptions","MessagePacket","Messages","MessagesNotebook","MetaCharacters","MetaInformation","MeteorShowerData","Method","MethodOptions","MexicanHatWavelet","MeyerWavelet","Midpoint","Min","MinColorDistance","MinDate","MinDetect","MineralData","MinFilter","MinimalBy","MinimalPolynomial","MinimalStateSpaceModel","Minimize","MinimumTimeIncrement","MinIntervalSize","MinkowskiQuestionMark","MinLimit","MinMax","MinorPlanetData","Minors","MinRecursion","MinSize","MinStableDistribution","Minus","MinusPlus","MinValue","Missing","MissingBehavior","MissingDataMethod","MissingDataRules","MissingQ","MissingString","MissingStyle","MissingValuePattern","MittagLefflerE","MixedFractionParts","MixedGraphQ","MixedMagnitude","MixedRadix","MixedRadixQuantity","MixedUnit","MixtureDistribution","Mod","Modal","Mode","Modular","ModularInverse","ModularLambda","Module","Modulus","MoebiusMu","Molecule","MoleculeContainsQ","MoleculeEquivalentQ","MoleculeGraph","MoleculeModify","MoleculePattern","MoleculePlot","MoleculePlot3D","MoleculeProperty","MoleculeQ","MoleculeRecognize","MoleculeValue","Moment","Momentary","MomentConvert","MomentEvaluate","MomentGeneratingFunction","MomentOfInertia","Monday","Monitor","MonomialList","MonomialOrder","MonsterGroupM","MoonPhase","MoonPosition","MorletWavelet","MorphologicalBinarize","MorphologicalBranchPoints","MorphologicalComponents","MorphologicalEulerNumber","MorphologicalGraph","MorphologicalPerimeter","MorphologicalTransform","MortalityData","Most","MountainData","MouseAnnotation","MouseAppearance","MouseAppearanceTag","MouseButtons","Mouseover","MousePointerNote","MousePosition","MovieData","MovingAverage","MovingMap","MovingMedian","MoyalDistribution","Multicolumn","MultiedgeStyle","MultigraphQ","MultilaunchWarning","MultiLetterItalics","MultiLetterStyle","MultilineFunction","Multinomial","MultinomialDistribution","MultinormalDistribution","MultiplicativeOrder","Multiplicity","MultiplySides","Multiselection","MultivariateHypergeometricDistribution","MultivariatePoissonDistribution","MultivariateTDistribution","N","NakagamiDistribution","NameQ","Names","NamespaceBox","NamespaceBoxOptions","Nand","NArgMax","NArgMin","NBernoulliB","NBodySimulation","NBodySimulationData","NCache","NDEigensystem","NDEigenvalues","NDSolve","NDSolveValue","Nearest","NearestFunction","NearestMeshCells","NearestNeighborGraph","NearestTo","NebulaData","NeedCurrentFrontEndPackagePacket","NeedCurrentFrontEndSymbolsPacket","NeedlemanWunschSimilarity","Needs","Negative","NegativeBinomialDistribution","NegativeDefiniteMatrixQ","NegativeIntegers","NegativeMultinomialDistribution","NegativeRationals","NegativeReals","NegativeSemidefiniteMatrixQ","NeighborhoodData","NeighborhoodGraph","Nest","NestedGreaterGreater","NestedLessLess","NestedScriptRules","NestGraph","NestList","NestWhile","NestWhileList","NetAppend","NetBidirectionalOperator","NetChain","NetDecoder","NetDelete","NetDrop","NetEncoder","NetEvaluationMode","NetExtract","NetFlatten","NetFoldOperator","NetGANOperator","NetGraph","NetInformation","NetInitialize","NetInsert","NetInsertSharedArrays","NetJoin","NetMapOperator","NetMapThreadOperator","NetMeasurements","NetModel","NetNestOperator","NetPairEmbeddingOperator","NetPort","NetPortGradient","NetPrepend","NetRename","NetReplace","NetReplacePart","NetSharedArray","NetStateObject","NetTake","NetTrain","NetTrainResultsObject","NetworkPacketCapture","NetworkPacketRecording","NetworkPacketRecordingDuring","NetworkPacketTrace","NeumannValue","NevilleThetaC","NevilleThetaD","NevilleThetaN","NevilleThetaS","NewPrimitiveStyle","NExpectation","Next","NextCell","NextDate","NextPrime","NextScheduledTaskTime","NHoldAll","NHoldFirst","NHoldRest","NicholsGridLines","NicholsPlot","NightHemisphere","NIntegrate","NMaximize","NMaxValue","NMinimize","NMinValue","NominalVariables","NonAssociative","NoncentralBetaDistribution","NoncentralChiSquareDistribution","NoncentralFRatioDistribution","NoncentralStudentTDistribution","NonCommutativeMultiply","NonConstants","NondimensionalizationTransform","None","NoneTrue","NonlinearModelFit","NonlinearStateSpaceModel","NonlocalMeansFilter","NonNegative","NonNegativeIntegers","NonNegativeRationals","NonNegativeReals","NonPositive","NonPositiveIntegers","NonPositiveRationals","NonPositiveReals","Nor","NorlundB","Norm","Normal","NormalDistribution","NormalGrouping","NormalizationLayer","Normalize","Normalized","NormalizedSquaredEuclideanDistance","NormalMatrixQ","NormalsFunction","NormFunction","Not","NotCongruent","NotCupCap","NotDoubleVerticalBar","Notebook","NotebookApply","NotebookAutoSave","NotebookClose","NotebookConvertSettings","NotebookCreate","NotebookCreateReturnObject","NotebookDefault","NotebookDelete","NotebookDirectory","NotebookDynamicExpression","NotebookEvaluate","NotebookEventActions","NotebookFileName","NotebookFind","NotebookFindReturnObject","NotebookGet","NotebookGetLayoutInformationPacket","NotebookGetMisspellingsPacket","NotebookImport","NotebookInformation","NotebookInterfaceObject","NotebookLocate","NotebookObject","NotebookOpen","NotebookOpenReturnObject","NotebookPath","NotebookPrint","NotebookPut","NotebookPutReturnObject","NotebookRead","NotebookResetGeneratedCells","Notebooks","NotebookSave","NotebookSaveAs","NotebookSelection","NotebookSetupLayoutInformationPacket","NotebooksMenu","NotebookTemplate","NotebookWrite","NotElement","NotEqualTilde","NotExists","NotGreater","NotGreaterEqual","NotGreaterFullEqual","NotGreaterGreater","NotGreaterLess","NotGreaterSlantEqual","NotGreaterTilde","Nothing","NotHumpDownHump","NotHumpEqual","NotificationFunction","NotLeftTriangle","NotLeftTriangleBar","NotLeftTriangleEqual","NotLess","NotLessEqual","NotLessFullEqual","NotLessGreater","NotLessLess","NotLessSlantEqual","NotLessTilde","NotNestedGreaterGreater","NotNestedLessLess","NotPrecedes","NotPrecedesEqual","NotPrecedesSlantEqual","NotPrecedesTilde","NotReverseElement","NotRightTriangle","NotRightTriangleBar","NotRightTriangleEqual","NotSquareSubset","NotSquareSubsetEqual","NotSquareSuperset","NotSquareSupersetEqual","NotSubset","NotSubsetEqual","NotSucceeds","NotSucceedsEqual","NotSucceedsSlantEqual","NotSucceedsTilde","NotSuperset","NotSupersetEqual","NotTilde","NotTildeEqual","NotTildeFullEqual","NotTildeTilde","NotVerticalBar","Now","NoWhitespace","NProbability","NProduct","NProductFactors","NRoots","NSolve","NSum","NSumTerms","NuclearExplosionData","NuclearReactorData","Null","NullRecords","NullSpace","NullWords","Number","NumberCompose","NumberDecompose","NumberExpand","NumberFieldClassNumber","NumberFieldDiscriminant","NumberFieldFundamentalUnits","NumberFieldIntegralBasis","NumberFieldNormRepresentatives","NumberFieldRegulator","NumberFieldRootsOfUnity","NumberFieldSignature","NumberForm","NumberFormat","NumberLinePlot","NumberMarks","NumberMultiplier","NumberPadding","NumberPoint","NumberQ","NumberSeparator","NumberSigns","NumberString","Numerator","NumeratorDenominator","NumericalOrder","NumericalSort","NumericArray","NumericArrayQ","NumericArrayType","NumericFunction","NumericQ","NuttallWindow","NValues","NyquistGridLines","NyquistPlot","O","ObservabilityGramian","ObservabilityMatrix","ObservableDecomposition","ObservableModelQ","OceanData","Octahedron","OddQ","Off","Offset","OLEData","On","ONanGroupON","Once","OneIdentity","Opacity","OpacityFunction","OpacityFunctionScaling","Open","OpenAppend","Opener","OpenerBox","OpenerBoxOptions","OpenerView","OpenFunctionInspectorPacket","Opening","OpenRead","OpenSpecialOptions","OpenTemporary","OpenWrite","Operate","OperatingSystem","OperatorApplied","OptimumFlowData","Optional","OptionalElement","OptionInspectorSettings","OptionQ","Options","OptionsPacket","OptionsPattern","OptionValue","OptionValueBox","OptionValueBoxOptions","Or","Orange","Order","OrderDistribution","OrderedQ","Ordering","OrderingBy","OrderingLayer","Orderless","OrderlessPatternSequence","OrnsteinUhlenbeckProcess","Orthogonalize","OrthogonalMatrixQ","Out","Outer","OuterPolygon","OuterPolyhedron","OutputAutoOverwrite","OutputControllabilityMatrix","OutputControllableModelQ","OutputForm","OutputFormData","OutputGrouping","OutputMathEditExpression","OutputNamePacket","OutputResponse","OutputSizeLimit","OutputStream","Over","OverBar","OverDot","Overflow","OverHat","Overlaps","Overlay","OverlayBox","OverlayBoxOptions","Overscript","OverscriptBox","OverscriptBoxOptions","OverTilde","OverVector","OverwriteTarget","OwenT","OwnValues","Package","PackingMethod","PackPaclet","PacletDataRebuild","PacletDirectoryAdd","PacletDirectoryLoad","PacletDirectoryRemove","PacletDirectoryUnload","PacletDisable","PacletEnable","PacletFind","PacletFindRemote","PacletInformation","PacletInstall","PacletInstallSubmit","PacletNewerQ","PacletObject","PacletObjectQ","PacletSite","PacletSiteObject","PacletSiteRegister","PacletSites","PacletSiteUnregister","PacletSiteUpdate","PacletUninstall","PacletUpdate","PaddedForm","Padding","PaddingLayer","PaddingSize","PadeApproximant","PadLeft","PadRight","PageBreakAbove","PageBreakBelow","PageBreakWithin","PageFooterLines","PageFooters","PageHeaderLines","PageHeaders","PageHeight","PageRankCentrality","PageTheme","PageWidth","Pagination","PairedBarChart","PairedHistogram","PairedSmoothHistogram","PairedTTest","PairedZTest","PaletteNotebook","PalettePath","PalindromeQ","Pane","PaneBox","PaneBoxOptions","Panel","PanelBox","PanelBoxOptions","Paneled","PaneSelector","PaneSelectorBox","PaneSelectorBoxOptions","PaperWidth","ParabolicCylinderD","ParagraphIndent","ParagraphSpacing","ParallelArray","ParallelCombine","ParallelDo","Parallelepiped","ParallelEvaluate","Parallelization","Parallelize","ParallelMap","ParallelNeeds","Parallelogram","ParallelProduct","ParallelSubmit","ParallelSum","ParallelTable","ParallelTry","Parameter","ParameterEstimator","ParameterMixtureDistribution","ParameterVariables","ParametricFunction","ParametricNDSolve","ParametricNDSolveValue","ParametricPlot","ParametricPlot3D","ParametricRampLayer","ParametricRegion","ParentBox","ParentCell","ParentConnect","ParentDirectory","ParentForm","Parenthesize","ParentList","ParentNotebook","ParetoDistribution","ParetoPickandsDistribution","ParkData","Part","PartBehavior","PartialCorrelationFunction","PartialD","ParticleAcceleratorData","ParticleData","Partition","PartitionGranularity","PartitionsP","PartitionsQ","PartLayer","PartOfSpeech","PartProtection","ParzenWindow","PascalDistribution","PassEventsDown","PassEventsUp","Paste","PasteAutoQuoteCharacters","PasteBoxFormInlineCells","PasteButton","Path","PathGraph","PathGraphQ","Pattern","PatternFilling","PatternSequence","PatternTest","PauliMatrix","PaulWavelet","Pause","PausedTime","PDF","PeakDetect","PeanoCurve","PearsonChiSquareTest","PearsonCorrelationTest","PearsonDistribution","PercentForm","PerfectNumber","PerfectNumberQ","PerformanceGoal","Perimeter","PeriodicBoundaryCondition","PeriodicInterpolation","Periodogram","PeriodogramArray","Permanent","Permissions","PermissionsGroup","PermissionsGroupMemberQ","PermissionsGroups","PermissionsKey","PermissionsKeys","PermutationCycles","PermutationCyclesQ","PermutationGroup","PermutationLength","PermutationList","PermutationListQ","PermutationMax","PermutationMin","PermutationOrder","PermutationPower","PermutationProduct","PermutationReplace","Permutations","PermutationSupport","Permute","PeronaMalikFilter","Perpendicular","PerpendicularBisector","PersistenceLocation","PersistenceTime","PersistentObject","PersistentObjects","PersistentValue","PersonData","PERTDistribution","PetersenGraph","PhaseMargins","PhaseRange","PhysicalSystemData","Pi","Pick","PIDData","PIDDerivativeFilter","PIDFeedforward","PIDTune","Piecewise","PiecewiseExpand","PieChart","PieChart3D","PillaiTrace","PillaiTraceTest","PingTime","Pink","PitchRecognize","Pivoting","PixelConstrained","PixelValue","PixelValuePositions","Placed","Placeholder","PlaceholderReplace","Plain","PlanarAngle","PlanarGraph","PlanarGraphQ","PlanckRadiationLaw","PlaneCurveData","PlanetaryMoonData","PlanetData","PlantData","Play","PlayRange","Plot","Plot3D","Plot3Matrix","PlotDivision","PlotJoined","PlotLabel","PlotLabels","PlotLayout","PlotLegends","PlotMarkers","PlotPoints","PlotRange","PlotRangeClipping","PlotRangeClipPlanesStyle","PlotRangePadding","PlotRegion","PlotStyle","PlotTheme","Pluralize","Plus","PlusMinus","Pochhammer","PodStates","PodWidth","Point","Point3DBox","Point3DBoxOptions","PointBox","PointBoxOptions","PointFigureChart","PointLegend","PointSize","PoissonConsulDistribution","PoissonDistribution","PoissonProcess","PoissonWindow","PolarAxes","PolarAxesOrigin","PolarGridLines","PolarPlot","PolarTicks","PoleZeroMarkers","PolyaAeppliDistribution","PolyGamma","Polygon","Polygon3DBox","Polygon3DBoxOptions","PolygonalNumber","PolygonAngle","PolygonBox","PolygonBoxOptions","PolygonCoordinates","PolygonDecomposition","PolygonHoleScale","PolygonIntersections","PolygonScale","Polyhedron","PolyhedronAngle","PolyhedronCoordinates","PolyhedronData","PolyhedronDecomposition","PolyhedronGenus","PolyLog","PolynomialExtendedGCD","PolynomialForm","PolynomialGCD","PolynomialLCM","PolynomialMod","PolynomialQ","PolynomialQuotient","PolynomialQuotientRemainder","PolynomialReduce","PolynomialRemainder","Polynomials","PoolingLayer","PopupMenu","PopupMenuBox","PopupMenuBoxOptions","PopupView","PopupWindow","Position","PositionIndex","Positive","PositiveDefiniteMatrixQ","PositiveIntegers","PositiveRationals","PositiveReals","PositiveSemidefiniteMatrixQ","PossibleZeroQ","Postfix","PostScript","Power","PowerDistribution","PowerExpand","PowerMod","PowerModList","PowerRange","PowerSpectralDensity","PowersRepresentations","PowerSymmetricPolynomial","Precedence","PrecedenceForm","Precedes","PrecedesEqual","PrecedesSlantEqual","PrecedesTilde","Precision","PrecisionGoal","PreDecrement","Predict","PredictionRoot","PredictorFunction","PredictorInformation","PredictorMeasurements","PredictorMeasurementsObject","PreemptProtect","PreferencesPath","Prefix","PreIncrement","Prepend","PrependLayer","PrependTo","PreprocessingRules","PreserveColor","PreserveImageOptions","Previous","PreviousCell","PreviousDate","PriceGraphDistribution","PrimaryPlaceholder","Prime","PrimeNu","PrimeOmega","PrimePi","PrimePowerQ","PrimeQ","Primes","PrimeZetaP","PrimitivePolynomialQ","PrimitiveRoot","PrimitiveRootList","PrincipalComponents","PrincipalValue","Print","PrintableASCIIQ","PrintAction","PrintForm","PrintingCopies","PrintingOptions","PrintingPageRange","PrintingStartingPageNumber","PrintingStyleEnvironment","Printout3D","Printout3DPreviewer","PrintPrecision","PrintTemporary","Prism","PrismBox","PrismBoxOptions","PrivateCellOptions","PrivateEvaluationOptions","PrivateFontOptions","PrivateFrontEndOptions","PrivateKey","PrivateNotebookOptions","PrivatePaths","Probability","ProbabilityDistribution","ProbabilityPlot","ProbabilityPr","ProbabilityScalePlot","ProbitModelFit","ProcessConnection","ProcessDirectory","ProcessEnvironment","Processes","ProcessEstimator","ProcessInformation","ProcessObject","ProcessParameterAssumptions","ProcessParameterQ","ProcessStateDomain","ProcessStatus","ProcessTimeDomain","Product","ProductDistribution","ProductLog","ProgressIndicator","ProgressIndicatorBox","ProgressIndicatorBoxOptions","Projection","Prolog","PromptForm","ProofObject","Properties","Property","PropertyList","PropertyValue","Proportion","Proportional","Protect","Protected","ProteinData","Pruning","PseudoInverse","PsychrometricPropertyData","PublicKey","PublisherID","PulsarData","PunctuationCharacter","Purple","Put","PutAppend","Pyramid","PyramidBox","PyramidBoxOptions","QBinomial","QFactorial","QGamma","QHypergeometricPFQ","QnDispersion","QPochhammer","QPolyGamma","QRDecomposition","QuadraticIrrationalQ","QuadraticOptimization","Quantile","QuantilePlot","Quantity","QuantityArray","QuantityDistribution","QuantityForm","QuantityMagnitude","QuantityQ","QuantityUnit","QuantityVariable","QuantityVariableCanonicalUnit","QuantityVariableDimensions","QuantityVariableIdentifier","QuantityVariablePhysicalQuantity","Quartics","QuartileDeviation","Quartiles","QuartileSkewness","Query","QueueingNetworkProcess","QueueingProcess","QueueProperties","Quiet","Quit","Quotient","QuotientRemainder","RadialGradientImage","RadialityCentrality","RadicalBox","RadicalBoxOptions","RadioButton","RadioButtonBar","RadioButtonBox","RadioButtonBoxOptions","Radon","RadonTransform","RamanujanTau","RamanujanTauL","RamanujanTauTheta","RamanujanTauZ","Ramp","Random","RandomChoice","RandomColor","RandomComplex","RandomEntity","RandomFunction","RandomGeoPosition","RandomGraph","RandomImage","RandomInstance","RandomInteger","RandomPermutation","RandomPoint","RandomPolygon","RandomPolyhedron","RandomPrime","RandomReal","RandomSample","RandomSeed","RandomSeeding","RandomVariate","RandomWalkProcess","RandomWord","Range","RangeFilter","RangeSpecification","RankedMax","RankedMin","RarerProbability","Raster","Raster3D","Raster3DBox","Raster3DBoxOptions","RasterArray","RasterBox","RasterBoxOptions","Rasterize","RasterSize","Rational","RationalFunctions","Rationalize","Rationals","Ratios","RawArray","RawBoxes","RawData","RawMedium","RayleighDistribution","Re","Read","ReadByteArray","ReadLine","ReadList","ReadProtected","ReadString","Real","RealAbs","RealBlockDiagonalForm","RealDigits","RealExponent","Reals","RealSign","Reap","RebuildPacletData","RecognitionPrior","RecognitionThreshold","Record","RecordLists","RecordSeparators","Rectangle","RectangleBox","RectangleBoxOptions","RectangleChart","RectangleChart3D","RectangularRepeatingElement","RecurrenceFilter","RecurrenceTable","RecurringDigitsForm","Red","Reduce","RefBox","ReferenceLineStyle","ReferenceMarkers","ReferenceMarkerStyle","Refine","ReflectionMatrix","ReflectionTransform","Refresh","RefreshRate","Region","RegionBinarize","RegionBoundary","RegionBoundaryStyle","RegionBounds","RegionCentroid","RegionDifference","RegionDimension","RegionDisjoint","RegionDistance","RegionDistanceFunction","RegionEmbeddingDimension","RegionEqual","RegionFillingStyle","RegionFunction","RegionImage","RegionIntersection","RegionMeasure","RegionMember","RegionMemberFunction","RegionMoment","RegionNearest","RegionNearestFunction","RegionPlot","RegionPlot3D","RegionProduct","RegionQ","RegionResize","RegionSize","RegionSymmetricDifference","RegionUnion","RegionWithin","RegisterExternalEvaluator","RegularExpression","Regularization","RegularlySampledQ","RegularPolygon","ReIm","ReImLabels","ReImPlot","ReImStyle","Reinstall","RelationalDatabase","RelationGraph","Release","ReleaseHold","ReliabilityDistribution","ReliefImage","ReliefPlot","RemoteAuthorizationCaching","RemoteConnect","RemoteConnectionObject","RemoteFile","RemoteRun","RemoteRunProcess","Remove","RemoveAlphaChannel","RemoveAsynchronousTask","RemoveAudioStream","RemoveBackground","RemoveChannelListener","RemoveChannelSubscribers","Removed","RemoveDiacritics","RemoveInputStreamMethod","RemoveOutputStreamMethod","RemoveProperty","RemoveScheduledTask","RemoveUsers","RemoveVideoStream","RenameDirectory","RenameFile","RenderAll","RenderingOptions","RenewalProcess","RenkoChart","RepairMesh","Repeated","RepeatedNull","RepeatedString","RepeatedTiming","RepeatingElement","Replace","ReplaceAll","ReplaceHeldPart","ReplaceImageValue","ReplaceList","ReplacePart","ReplacePixelValue","ReplaceRepeated","ReplicateLayer","RequiredPhysicalQuantities","Resampling","ResamplingAlgorithmData","ResamplingMethod","Rescale","RescalingTransform","ResetDirectory","ResetMenusPacket","ResetScheduledTask","ReshapeLayer","Residue","ResizeLayer","Resolve","ResourceAcquire","ResourceData","ResourceFunction","ResourceObject","ResourceRegister","ResourceRemove","ResourceSearch","ResourceSubmissionObject","ResourceSubmit","ResourceSystemBase","ResourceSystemPath","ResourceUpdate","ResourceVersion","ResponseForm","Rest","RestartInterval","Restricted","Resultant","ResumePacket","Return","ReturnEntersInput","ReturnExpressionPacket","ReturnInputFormPacket","ReturnPacket","ReturnReceiptFunction","ReturnTextPacket","Reverse","ReverseApplied","ReverseBiorthogonalSplineWavelet","ReverseElement","ReverseEquilibrium","ReverseGraph","ReverseSort","ReverseSortBy","ReverseUpEquilibrium","RevolutionAxis","RevolutionPlot3D","RGBColor","RiccatiSolve","RiceDistribution","RidgeFilter","RiemannR","RiemannSiegelTheta","RiemannSiegelZ","RiemannXi","Riffle","Right","RightArrow","RightArrowBar","RightArrowLeftArrow","RightComposition","RightCosetRepresentative","RightDownTeeVector","RightDownVector","RightDownVectorBar","RightTee","RightTeeArrow","RightTeeVector","RightTriangle","RightTriangleBar","RightTriangleEqual","RightUpDownVector","RightUpTeeVector","RightUpVector","RightUpVectorBar","RightVector","RightVectorBar","RiskAchievementImportance","RiskReductionImportance","RogersTanimotoDissimilarity","RollPitchYawAngles","RollPitchYawMatrix","RomanNumeral","Root","RootApproximant","RootIntervals","RootLocusPlot","RootMeanSquare","RootOfUnityQ","RootReduce","Roots","RootSum","Rotate","RotateLabel","RotateLeft","RotateRight","RotationAction","RotationBox","RotationBoxOptions","RotationMatrix","RotationTransform","Round","RoundImplies","RoundingRadius","Row","RowAlignments","RowBackgrounds","RowBox","RowHeights","RowLines","RowMinHeight","RowReduce","RowsEqual","RowSpacings","RSolve","RSolveValue","RudinShapiro","RudvalisGroupRu","Rule","RuleCondition","RuleDelayed","RuleForm","RulePlot","RulerUnits","Run","RunProcess","RunScheduledTask","RunThrough","RuntimeAttributes","RuntimeOptions","RussellRaoDissimilarity","SameQ","SameTest","SameTestProperties","SampledEntityClass","SampleDepth","SampledSoundFunction","SampledSoundList","SampleRate","SamplingPeriod","SARIMAProcess","SARMAProcess","SASTriangle","SatelliteData","SatisfiabilityCount","SatisfiabilityInstances","SatisfiableQ","Saturday","Save","Saveable","SaveAutoDelete","SaveConnection","SaveDefinitions","SavitzkyGolayMatrix","SawtoothWave","Scale","Scaled","ScaleDivisions","ScaledMousePosition","ScaleOrigin","ScalePadding","ScaleRanges","ScaleRangeStyle","ScalingFunctions","ScalingMatrix","ScalingTransform","Scan","ScheduledTask","ScheduledTaskActiveQ","ScheduledTaskInformation","ScheduledTaskInformationData","ScheduledTaskObject","ScheduledTasks","SchurDecomposition","ScientificForm","ScientificNotationThreshold","ScorerGi","ScorerGiPrime","ScorerHi","ScorerHiPrime","ScreenRectangle","ScreenStyleEnvironment","ScriptBaselineShifts","ScriptForm","ScriptLevel","ScriptMinSize","ScriptRules","ScriptSizeMultipliers","Scrollbars","ScrollingOptions","ScrollPosition","SearchAdjustment","SearchIndexObject","SearchIndices","SearchQueryString","SearchResultObject","Sec","Sech","SechDistribution","SecondOrderConeOptimization","SectionGrouping","SectorChart","SectorChart3D","SectorOrigin","SectorSpacing","SecuredAuthenticationKey","SecuredAuthenticationKeys","SeedRandom","Select","Selectable","SelectComponents","SelectedCells","SelectedNotebook","SelectFirst","Selection","SelectionAnimate","SelectionCell","SelectionCellCreateCell","SelectionCellDefaultStyle","SelectionCellParentStyle","SelectionCreateCell","SelectionDebuggerTag","SelectionDuplicateCell","SelectionEvaluate","SelectionEvaluateCreateCell","SelectionMove","SelectionPlaceholder","SelectionSetStyle","SelectWithContents","SelfLoops","SelfLoopStyle","SemanticImport","SemanticImportString","SemanticInterpretation","SemialgebraicComponentInstances","SemidefiniteOptimization","SendMail","SendMessage","Sequence","SequenceAlignment","SequenceAttentionLayer","SequenceCases","SequenceCount","SequenceFold","SequenceFoldList","SequenceForm","SequenceHold","SequenceLastLayer","SequenceMostLayer","SequencePosition","SequencePredict","SequencePredictorFunction","SequenceReplace","SequenceRestLayer","SequenceReverseLayer","SequenceSplit","Series","SeriesCoefficient","SeriesData","SeriesTermGoal","ServiceConnect","ServiceDisconnect","ServiceExecute","ServiceObject","ServiceRequest","ServiceResponse","ServiceSubmit","SessionSubmit","SessionTime","Set","SetAccuracy","SetAlphaChannel","SetAttributes","Setbacks","SetBoxFormNamesPacket","SetCloudDirectory","SetCookies","SetDelayed","SetDirectory","SetEnvironment","SetEvaluationNotebook","SetFileDate","SetFileLoadingContext","SetNotebookStatusLine","SetOptions","SetOptionsPacket","SetPermissions","SetPrecision","SetProperty","SetSecuredAuthenticationKey","SetSelectedNotebook","SetSharedFunction","SetSharedVariable","SetSpeechParametersPacket","SetStreamPosition","SetSystemModel","SetSystemOptions","Setter","SetterBar","SetterBox","SetterBoxOptions","Setting","SetUsers","SetValue","Shading","Shallow","ShannonWavelet","ShapiroWilkTest","Share","SharingList","Sharpen","ShearingMatrix","ShearingTransform","ShellRegion","ShenCastanMatrix","ShiftedGompertzDistribution","ShiftRegisterSequence","Short","ShortDownArrow","Shortest","ShortestMatch","ShortestPathFunction","ShortLeftArrow","ShortRightArrow","ShortTimeFourier","ShortTimeFourierData","ShortUpArrow","Show","ShowAutoConvert","ShowAutoSpellCheck","ShowAutoStyles","ShowCellBracket","ShowCellLabel","ShowCellTags","ShowClosedCellArea","ShowCodeAssist","ShowContents","ShowControls","ShowCursorTracker","ShowGroupOpenCloseIcon","ShowGroupOpener","ShowInvisibleCharacters","ShowPageBreaks","ShowPredictiveInterface","ShowSelection","ShowShortBoxForm","ShowSpecialCharacters","ShowStringCharacters","ShowSyntaxStyles","ShrinkingDelay","ShrinkWrapBoundingBox","SiderealTime","SiegelTheta","SiegelTukeyTest","SierpinskiCurve","SierpinskiMesh","Sign","Signature","SignedRankTest","SignedRegionDistance","SignificanceLevel","SignPadding","SignTest","SimilarityRules","SimpleGraph","SimpleGraphQ","SimplePolygonQ","SimplePolyhedronQ","Simplex","Simplify","Sin","Sinc","SinghMaddalaDistribution","SingleEvaluation","SingleLetterItalics","SingleLetterStyle","SingularValueDecomposition","SingularValueList","SingularValuePlot","SingularValues","Sinh","SinhIntegral","SinIntegral","SixJSymbol","Skeleton","SkeletonTransform","SkellamDistribution","Skewness","SkewNormalDistribution","SkinStyle","Skip","SliceContourPlot3D","SliceDensityPlot3D","SliceDistribution","SliceVectorPlot3D","Slider","Slider2D","Slider2DBox","Slider2DBoxOptions","SliderBox","SliderBoxOptions","SlideView","Slot","SlotSequence","Small","SmallCircle","Smaller","SmithDecomposition","SmithDelayCompensator","SmithWatermanSimilarity","SmoothDensityHistogram","SmoothHistogram","SmoothHistogram3D","SmoothKernelDistribution","SnDispersion","Snippet","SnubPolyhedron","SocialMediaData","Socket","SocketConnect","SocketListen","SocketListener","SocketObject","SocketOpen","SocketReadMessage","SocketReadyQ","Sockets","SocketWaitAll","SocketWaitNext","SoftmaxLayer","SokalSneathDissimilarity","SolarEclipse","SolarSystemFeatureData","SolidAngle","SolidData","SolidRegionQ","Solve","SolveAlways","SolveDelayed","Sort","SortBy","SortedBy","SortedEntityClass","Sound","SoundAndGraphics","SoundNote","SoundVolume","SourceLink","Sow","Space","SpaceCurveData","SpaceForm","Spacer","Spacings","Span","SpanAdjustments","SpanCharacterRounding","SpanFromAbove","SpanFromBoth","SpanFromLeft","SpanLineThickness","SpanMaxSize","SpanMinSize","SpanningCharacters","SpanSymmetric","SparseArray","SpatialGraphDistribution","SpatialMedian","SpatialTransformationLayer","Speak","SpeakerMatchQ","SpeakTextPacket","SpearmanRankTest","SpearmanRho","SpeciesData","SpecificityGoal","SpectralLineData","Spectrogram","SpectrogramArray","Specularity","SpeechCases","SpeechInterpreter","SpeechRecognize","SpeechSynthesize","SpellingCorrection","SpellingCorrectionList","SpellingDictionaries","SpellingDictionariesPath","SpellingOptions","SpellingSuggestionsPacket","Sphere","SphereBox","SpherePoints","SphericalBesselJ","SphericalBesselY","SphericalHankelH1","SphericalHankelH2","SphericalHarmonicY","SphericalPlot3D","SphericalRegion","SphericalShell","SpheroidalEigenvalue","SpheroidalJoiningFactor","SpheroidalPS","SpheroidalPSPrime","SpheroidalQS","SpheroidalQSPrime","SpheroidalRadialFactor","SpheroidalS1","SpheroidalS1Prime","SpheroidalS2","SpheroidalS2Prime","Splice","SplicedDistribution","SplineClosed","SplineDegree","SplineKnots","SplineWeights","Split","SplitBy","SpokenString","Sqrt","SqrtBox","SqrtBoxOptions","Square","SquaredEuclideanDistance","SquareFreeQ","SquareIntersection","SquareMatrixQ","SquareRepeatingElement","SquaresR","SquareSubset","SquareSubsetEqual","SquareSuperset","SquareSupersetEqual","SquareUnion","SquareWave","SSSTriangle","StabilityMargins","StabilityMarginsStyle","StableDistribution","Stack","StackBegin","StackComplete","StackedDateListPlot","StackedListPlot","StackInhibit","StadiumShape","StandardAtmosphereData","StandardDeviation","StandardDeviationFilter","StandardForm","Standardize","Standardized","StandardOceanData","StandbyDistribution","Star","StarClusterData","StarData","StarGraph","StartAsynchronousTask","StartExternalSession","StartingStepSize","StartOfLine","StartOfString","StartProcess","StartScheduledTask","StartupSound","StartWebSession","StateDimensions","StateFeedbackGains","StateOutputEstimator","StateResponse","StateSpaceModel","StateSpaceRealization","StateSpaceTransform","StateTransformationLinearize","StationaryDistribution","StationaryWaveletPacketTransform","StationaryWaveletTransform","StatusArea","StatusCentrality","StepMonitor","StereochemistryElements","StieltjesGamma","StippleShading","StirlingS1","StirlingS2","StopAsynchronousTask","StoppingPowerData","StopScheduledTask","StrataVariables","StratonovichProcess","StreamColorFunction","StreamColorFunctionScaling","StreamDensityPlot","StreamMarkers","StreamPlot","StreamPoints","StreamPosition","Streams","StreamScale","StreamStyle","String","StringBreak","StringByteCount","StringCases","StringContainsQ","StringCount","StringDelete","StringDrop","StringEndsQ","StringExpression","StringExtract","StringForm","StringFormat","StringFreeQ","StringInsert","StringJoin","StringLength","StringMatchQ","StringPadLeft","StringPadRight","StringPart","StringPartition","StringPosition","StringQ","StringRepeat","StringReplace","StringReplaceList","StringReplacePart","StringReverse","StringRiffle","StringRotateLeft","StringRotateRight","StringSkeleton","StringSplit","StringStartsQ","StringTake","StringTemplate","StringToByteArray","StringToStream","StringTrim","StripBoxes","StripOnInput","StripWrapperBoxes","StrokeForm","StructuralImportance","StructuredArray","StructuredArrayHeadQ","StructuredSelection","StruveH","StruveL","Stub","StudentTDistribution","Style","StyleBox","StyleBoxAutoDelete","StyleData","StyleDefinitions","StyleForm","StyleHints","StyleKeyMapping","StyleMenuListing","StyleNameDialogSettings","StyleNames","StylePrint","StyleSheetPath","Subdivide","Subfactorial","Subgraph","SubMinus","SubPlus","SubresultantPolynomialRemainders","SubresultantPolynomials","Subresultants","Subscript","SubscriptBox","SubscriptBoxOptions","Subscripted","Subsequences","Subset","SubsetCases","SubsetCount","SubsetEqual","SubsetMap","SubsetPosition","SubsetQ","SubsetReplace","Subsets","SubStar","SubstitutionSystem","Subsuperscript","SubsuperscriptBox","SubsuperscriptBoxOptions","SubtitleEncoding","SubtitleTracks","Subtract","SubtractFrom","SubtractSides","SubValues","Succeeds","SucceedsEqual","SucceedsSlantEqual","SucceedsTilde","Success","SuchThat","Sum","SumConvergence","SummationLayer","Sunday","SunPosition","Sunrise","Sunset","SuperDagger","SuperMinus","SupernovaData","SuperPlus","Superscript","SuperscriptBox","SuperscriptBoxOptions","Superset","SupersetEqual","SuperStar","Surd","SurdForm","SurfaceAppearance","SurfaceArea","SurfaceColor","SurfaceData","SurfaceGraphics","SurvivalDistribution","SurvivalFunction","SurvivalModel","SurvivalModelFit","SuspendPacket","SuzukiDistribution","SuzukiGroupSuz","SwatchLegend","Switch","Symbol","SymbolName","SymletWavelet","Symmetric","SymmetricGroup","SymmetricKey","SymmetricMatrixQ","SymmetricPolynomial","SymmetricReduction","Symmetrize","SymmetrizedArray","SymmetrizedArrayRules","SymmetrizedDependentComponents","SymmetrizedIndependentComponents","SymmetrizedReplacePart","SynchronousInitialization","SynchronousUpdating","Synonyms","Syntax","SyntaxForm","SyntaxInformation","SyntaxLength","SyntaxPacket","SyntaxQ","SynthesizeMissingValues","SystemCredential","SystemCredentialData","SystemCredentialKey","SystemCredentialKeys","SystemCredentialStoreObject","SystemDialogInput","SystemException","SystemGet","SystemHelpPath","SystemInformation","SystemInformationData","SystemInstall","SystemModel","SystemModeler","SystemModelExamples","SystemModelLinearize","SystemModelParametricSimulate","SystemModelPlot","SystemModelProgressReporting","SystemModelReliability","SystemModels","SystemModelSimulate","SystemModelSimulateSensitivity","SystemModelSimulationData","SystemOpen","SystemOptions","SystemProcessData","SystemProcesses","SystemsConnectionsModel","SystemsModelDelay","SystemsModelDelayApproximate","SystemsModelDelete","SystemsModelDimensions","SystemsModelExtract","SystemsModelFeedbackConnect","SystemsModelLabels","SystemsModelLinearity","SystemsModelMerge","SystemsModelOrder","SystemsModelParallelConnect","SystemsModelSeriesConnect","SystemsModelStateFeedbackConnect","SystemsModelVectorRelativeOrders","SystemStub","SystemTest","Tab","TabFilling","Table","TableAlignments","TableDepth","TableDirections","TableForm","TableHeadings","TableSpacing","TableView","TableViewBox","TableViewBoxBackground","TableViewBoxItemSize","TableViewBoxOptions","TabSpacings","TabView","TabViewBox","TabViewBoxOptions","TagBox","TagBoxNote","TagBoxOptions","TaggingRules","TagSet","TagSetDelayed","TagStyle","TagUnset","Take","TakeDrop","TakeLargest","TakeLargestBy","TakeList","TakeSmallest","TakeSmallestBy","TakeWhile","Tally","Tan","Tanh","TargetDevice","TargetFunctions","TargetSystem","TargetUnits","TaskAbort","TaskExecute","TaskObject","TaskRemove","TaskResume","Tasks","TaskSuspend","TaskWait","TautologyQ","TelegraphProcess","TemplateApply","TemplateArgBox","TemplateBox","TemplateBoxOptions","TemplateEvaluate","TemplateExpression","TemplateIf","TemplateObject","TemplateSequence","TemplateSlot","TemplateSlotSequence","TemplateUnevaluated","TemplateVerbatim","TemplateWith","TemporalData","TemporalRegularity","Temporary","TemporaryVariable","TensorContract","TensorDimensions","TensorExpand","TensorProduct","TensorQ","TensorRank","TensorReduce","TensorSymmetry","TensorTranspose","TensorWedge","TestID","TestReport","TestReportObject","TestResultObject","Tetrahedron","TetrahedronBox","TetrahedronBoxOptions","TeXForm","TeXSave","Text","Text3DBox","Text3DBoxOptions","TextAlignment","TextBand","TextBoundingBox","TextBox","TextCases","TextCell","TextClipboardType","TextContents","TextData","TextElement","TextForm","TextGrid","TextJustification","TextLine","TextPacket","TextParagraph","TextPosition","TextRecognize","TextSearch","TextSearchReport","TextSentences","TextString","TextStructure","TextStyle","TextTranslation","Texture","TextureCoordinateFunction","TextureCoordinateScaling","TextWords","Therefore","ThermodynamicData","ThermometerGauge","Thick","Thickness","Thin","Thinning","ThisLink","ThompsonGroupTh","Thread","ThreadingLayer","ThreeJSymbol","Threshold","Through","Throw","ThueMorse","Thumbnail","Thursday","Ticks","TicksStyle","TideData","Tilde","TildeEqual","TildeFullEqual","TildeTilde","TimeConstrained","TimeConstraint","TimeDirection","TimeFormat","TimeGoal","TimelinePlot","TimeObject","TimeObjectQ","TimeRemaining","Times","TimesBy","TimeSeries","TimeSeriesAggregate","TimeSeriesForecast","TimeSeriesInsert","TimeSeriesInvertibility","TimeSeriesMap","TimeSeriesMapThread","TimeSeriesModel","TimeSeriesModelFit","TimeSeriesResample","TimeSeriesRescale","TimeSeriesShift","TimeSeriesThread","TimeSeriesWindow","TimeUsed","TimeValue","TimeWarpingCorrespondence","TimeWarpingDistance","TimeZone","TimeZoneConvert","TimeZoneOffset","Timing","Tiny","TitleGrouping","TitsGroupT","ToBoxes","ToCharacterCode","ToColor","ToContinuousTimeModel","ToDate","Today","ToDiscreteTimeModel","ToEntity","ToeplitzMatrix","ToExpression","ToFileName","Together","Toggle","ToggleFalse","Toggler","TogglerBar","TogglerBox","TogglerBoxOptions","ToHeldExpression","ToInvertibleTimeSeries","TokenWords","Tolerance","ToLowerCase","Tomorrow","ToNumberField","TooBig","Tooltip","TooltipBox","TooltipBoxOptions","TooltipDelay","TooltipStyle","ToonShading","Top","TopHatTransform","ToPolarCoordinates","TopologicalSort","ToRadicals","ToRules","ToSphericalCoordinates","ToString","Total","TotalHeight","TotalLayer","TotalVariationFilter","TotalWidth","TouchPosition","TouchscreenAutoZoom","TouchscreenControlPlacement","ToUpperCase","Tr","Trace","TraceAbove","TraceAction","TraceBackward","TraceDepth","TraceDialog","TraceForward","TraceInternal","TraceLevel","TraceOff","TraceOn","TraceOriginal","TracePrint","TraceScan","TrackedSymbols","TrackingFunction","TracyWidomDistribution","TradingChart","TraditionalForm","TraditionalFunctionNotation","TraditionalNotation","TraditionalOrder","TrainingProgressCheckpointing","TrainingProgressFunction","TrainingProgressMeasurements","TrainingProgressReporting","TrainingStoppingCriterion","TrainingUpdateSchedule","TransferFunctionCancel","TransferFunctionExpand","TransferFunctionFactor","TransferFunctionModel","TransferFunctionPoles","TransferFunctionTransform","TransferFunctionZeros","TransformationClass","TransformationFunction","TransformationFunctions","TransformationMatrix","TransformedDistribution","TransformedField","TransformedProcess","TransformedRegion","TransitionDirection","TransitionDuration","TransitionEffect","TransitiveClosureGraph","TransitiveReductionGraph","Translate","TranslationOptions","TranslationTransform","Transliterate","Transparent","TransparentColor","Transpose","TransposeLayer","TrapSelection","TravelDirections","TravelDirectionsData","TravelDistance","TravelDistanceList","TravelMethod","TravelTime","TreeForm","TreeGraph","TreeGraphQ","TreePlot","TrendStyle","Triangle","TriangleCenter","TriangleConstruct","TriangleMeasurement","TriangleWave","TriangularDistribution","TriangulateMesh","Trig","TrigExpand","TrigFactor","TrigFactorList","Trigger","TrigReduce","TrigToExp","TrimmedMean","TrimmedVariance","TropicalStormData","True","TrueQ","TruncatedDistribution","TruncatedPolyhedron","TsallisQExponentialDistribution","TsallisQGaussianDistribution","TTest","Tube","TubeBezierCurveBox","TubeBezierCurveBoxOptions","TubeBox","TubeBoxOptions","TubeBSplineCurveBox","TubeBSplineCurveBoxOptions","Tuesday","TukeyLambdaDistribution","TukeyWindow","TunnelData","Tuples","TuranGraph","TuringMachine","TuttePolynomial","TwoWayRule","Typed","TypeSpecifier","UnateQ","Uncompress","UnconstrainedParameters","Undefined","UnderBar","Underflow","Underlined","Underoverscript","UnderoverscriptBox","UnderoverscriptBoxOptions","Underscript","UnderscriptBox","UnderscriptBoxOptions","UnderseaFeatureData","UndirectedEdge","UndirectedGraph","UndirectedGraphQ","UndoOptions","UndoTrackedVariables","Unequal","UnequalTo","Unevaluated","UniformDistribution","UniformGraphDistribution","UniformPolyhedron","UniformSumDistribution","Uninstall","Union","UnionedEntityClass","UnionPlus","Unique","UnitaryMatrixQ","UnitBox","UnitConvert","UnitDimensions","Unitize","UnitRootTest","UnitSimplify","UnitStep","UnitSystem","UnitTriangle","UnitVector","UnitVectorLayer","UnityDimensions","UniverseModelData","UniversityData","UnixTime","Unprotect","UnregisterExternalEvaluator","UnsameQ","UnsavedVariables","Unset","UnsetShared","UntrackedVariables","Up","UpArrow","UpArrowBar","UpArrowDownArrow","Update","UpdateDynamicObjects","UpdateDynamicObjectsSynchronous","UpdateInterval","UpdatePacletSites","UpdateSearchIndex","UpDownArrow","UpEquilibrium","UpperCaseQ","UpperLeftArrow","UpperRightArrow","UpperTriangularize","UpperTriangularMatrixQ","Upsample","UpSet","UpSetDelayed","UpTee","UpTeeArrow","UpTo","UpValues","URL","URLBuild","URLDecode","URLDispatcher","URLDownload","URLDownloadSubmit","URLEncode","URLExecute","URLExpand","URLFetch","URLFetchAsynchronous","URLParse","URLQueryDecode","URLQueryEncode","URLRead","URLResponseTime","URLSave","URLSaveAsynchronous","URLShorten","URLSubmit","UseGraphicsRange","UserDefinedWavelet","Using","UsingFrontEnd","UtilityFunction","V2Get","ValenceErrorHandling","ValidationLength","ValidationSet","Value","ValueBox","ValueBoxOptions","ValueDimensions","ValueForm","ValuePreprocessingFunction","ValueQ","Values","ValuesData","Variables","Variance","VarianceEquivalenceTest","VarianceEstimatorFunction","VarianceGammaDistribution","VarianceTest","VectorAngle","VectorAround","VectorAspectRatio","VectorColorFunction","VectorColorFunctionScaling","VectorDensityPlot","VectorGlyphData","VectorGreater","VectorGreaterEqual","VectorLess","VectorLessEqual","VectorMarkers","VectorPlot","VectorPlot3D","VectorPoints","VectorQ","VectorRange","Vectors","VectorScale","VectorScaling","VectorSizes","VectorStyle","Vee","Verbatim","Verbose","VerboseConvertToPostScriptPacket","VerificationTest","VerifyConvergence","VerifyDerivedKey","VerifyDigitalSignature","VerifyFileSignature","VerifyInterpretation","VerifySecurityCertificates","VerifySolutions","VerifyTestAssumptions","Version","VersionedPreferences","VersionNumber","VertexAdd","VertexCapacity","VertexColors","VertexComponent","VertexConnectivity","VertexContract","VertexCoordinateRules","VertexCoordinates","VertexCorrelationSimilarity","VertexCosineSimilarity","VertexCount","VertexCoverQ","VertexDataCoordinates","VertexDegree","VertexDelete","VertexDiceSimilarity","VertexEccentricity","VertexInComponent","VertexInDegree","VertexIndex","VertexJaccardSimilarity","VertexLabeling","VertexLabels","VertexLabelStyle","VertexList","VertexNormals","VertexOutComponent","VertexOutDegree","VertexQ","VertexRenderingFunction","VertexReplace","VertexShape","VertexShapeFunction","VertexSize","VertexStyle","VertexTextureCoordinates","VertexWeight","VertexWeightedGraphQ","Vertical","VerticalBar","VerticalForm","VerticalGauge","VerticalSeparator","VerticalSlider","VerticalTilde","Video","VideoEncoding","VideoExtractFrames","VideoFrameList","VideoFrameMap","VideoPause","VideoPlay","VideoQ","VideoStop","VideoStream","VideoStreams","VideoTimeSeries","VideoTracks","VideoTrim","ViewAngle","ViewCenter","ViewMatrix","ViewPoint","ViewPointSelectorSettings","ViewPort","ViewProjection","ViewRange","ViewVector","ViewVertical","VirtualGroupData","Visible","VisibleCell","VoiceStyleData","VoigtDistribution","VolcanoData","Volume","VonMisesDistribution","VoronoiMesh","WaitAll","WaitAsynchronousTask","WaitNext","WaitUntil","WakebyDistribution","WalleniusHypergeometricDistribution","WaringYuleDistribution","WarpingCorrespondence","WarpingDistance","WatershedComponents","WatsonUSquareTest","WattsStrogatzGraphDistribution","WaveletBestBasis","WaveletFilterCoefficients","WaveletImagePlot","WaveletListPlot","WaveletMapIndexed","WaveletMatrixPlot","WaveletPhi","WaveletPsi","WaveletScale","WaveletScalogram","WaveletThreshold","WeaklyConnectedComponents","WeaklyConnectedGraphComponents","WeaklyConnectedGraphQ","WeakStationarity","WeatherData","WeatherForecastData","WebAudioSearch","WebElementObject","WeberE","WebExecute","WebImage","WebImageSearch","WebSearch","WebSessionObject","WebSessions","WebWindowObject","Wedge","Wednesday","WeibullDistribution","WeierstrassE1","WeierstrassE2","WeierstrassE3","WeierstrassEta1","WeierstrassEta2","WeierstrassEta3","WeierstrassHalfPeriods","WeierstrassHalfPeriodW1","WeierstrassHalfPeriodW2","WeierstrassHalfPeriodW3","WeierstrassInvariantG2","WeierstrassInvariantG3","WeierstrassInvariants","WeierstrassP","WeierstrassPPrime","WeierstrassSigma","WeierstrassZeta","WeightedAdjacencyGraph","WeightedAdjacencyMatrix","WeightedData","WeightedGraphQ","Weights","WelchWindow","WheelGraph","WhenEvent","Which","While","White","WhiteNoiseProcess","WhitePoint","Whitespace","WhitespaceCharacter","WhittakerM","WhittakerW","WienerFilter","WienerProcess","WignerD","WignerSemicircleDistribution","WikidataData","WikidataSearch","WikipediaData","WikipediaSearch","WilksW","WilksWTest","WindDirectionData","WindingCount","WindingPolygon","WindowClickSelect","WindowElements","WindowFloating","WindowFrame","WindowFrameElements","WindowMargins","WindowMovable","WindowOpacity","WindowPersistentStyles","WindowSelected","WindowSize","WindowStatusArea","WindowTitle","WindowToolbars","WindowWidth","WindSpeedData","WindVectorData","WinsorizedMean","WinsorizedVariance","WishartMatrixDistribution","With","WolframAlpha","WolframAlphaDate","WolframAlphaQuantity","WolframAlphaResult","WolframLanguageData","Word","WordBoundary","WordCharacter","WordCloud","WordCount","WordCounts","WordData","WordDefinition","WordFrequency","WordFrequencyData","WordList","WordOrientation","WordSearch","WordSelectionFunction","WordSeparators","WordSpacings","WordStem","WordTranslation","WorkingPrecision","WrapAround","Write","WriteLine","WriteString","Wronskian","XMLElement","XMLObject","XMLTemplate","Xnor","Xor","XYZColor","Yellow","Yesterday","YuleDissimilarity","ZernikeR","ZeroSymmetric","ZeroTest","ZeroWidthTimes","Zeta","ZetaZero","ZIPCodeData","ZipfDistribution","ZoomCenter","ZoomFactor","ZTest","ZTransform","$Aborted","$ActivationGroupID","$ActivationKey","$ActivationUserRegistered","$AddOnsDirectory","$AllowDataUpdates","$AllowExternalChannelFunctions","$AllowInternet","$AssertFunction","$Assumptions","$AsynchronousTask","$AudioDecoders","$AudioEncoders","$AudioInputDevices","$AudioOutputDevices","$BaseDirectory","$BasePacletsDirectory","$BatchInput","$BatchOutput","$BlockchainBase","$BoxForms","$ByteOrdering","$CacheBaseDirectory","$Canceled","$ChannelBase","$CharacterEncoding","$CharacterEncodings","$CloudAccountName","$CloudBase","$CloudConnected","$CloudConnection","$CloudCreditsAvailable","$CloudEvaluation","$CloudExpressionBase","$CloudObjectNameFormat","$CloudObjectURLType","$CloudRootDirectory","$CloudSymbolBase","$CloudUserID","$CloudUserUUID","$CloudVersion","$CloudVersionNumber","$CloudWolframEngineVersionNumber","$CommandLine","$CompilationTarget","$ConditionHold","$ConfiguredKernels","$Context","$ContextPath","$ControlActiveSetting","$Cookies","$CookieStore","$CreationDate","$CurrentLink","$CurrentTask","$CurrentWebSession","$DataStructures","$DateStringFormat","$DefaultAudioInputDevice","$DefaultAudioOutputDevice","$DefaultFont","$DefaultFrontEnd","$DefaultImagingDevice","$DefaultLocalBase","$DefaultMailbox","$DefaultNetworkInterface","$DefaultPath","$DefaultProxyRules","$DefaultSystemCredentialStore","$Display","$DisplayFunction","$DistributedContexts","$DynamicEvaluation","$Echo","$EmbedCodeEnvironments","$EmbeddableServices","$EntityStores","$Epilog","$EvaluationCloudBase","$EvaluationCloudObject","$EvaluationEnvironment","$ExportFormats","$ExternalIdentifierTypes","$ExternalStorageBase","$Failed","$FinancialDataSource","$FontFamilies","$FormatType","$FrontEnd","$FrontEndSession","$GeoEntityTypes","$GeoLocation","$GeoLocationCity","$GeoLocationCountry","$GeoLocationPrecision","$GeoLocationSource","$HistoryLength","$HomeDirectory","$HTMLExportRules","$HTTPCookies","$HTTPRequest","$IgnoreEOF","$ImageFormattingWidth","$ImageResolution","$ImagingDevice","$ImagingDevices","$ImportFormats","$IncomingMailSettings","$InitialDirectory","$Initialization","$InitializationContexts","$Input","$InputFileName","$InputStreamMethods","$Inspector","$InstallationDate","$InstallationDirectory","$InterfaceEnvironment","$InterpreterTypes","$IterationLimit","$KernelCount","$KernelID","$Language","$LaunchDirectory","$LibraryPath","$LicenseExpirationDate","$LicenseID","$LicenseProcesses","$LicenseServer","$LicenseSubprocesses","$LicenseType","$Line","$Linked","$LinkSupported","$LoadedFiles","$LocalBase","$LocalSymbolBase","$MachineAddresses","$MachineDomain","$MachineDomains","$MachineEpsilon","$MachineID","$MachineName","$MachinePrecision","$MachineType","$MaxExtraPrecision","$MaxLicenseProcesses","$MaxLicenseSubprocesses","$MaxMachineNumber","$MaxNumber","$MaxPiecewiseCases","$MaxPrecision","$MaxRootDegree","$MessageGroups","$MessageList","$MessagePrePrint","$Messages","$MinMachineNumber","$MinNumber","$MinorReleaseNumber","$MinPrecision","$MobilePhone","$ModuleNumber","$NetworkConnected","$NetworkInterfaces","$NetworkLicense","$NewMessage","$NewSymbol","$NotebookInlineStorageLimit","$Notebooks","$NoValue","$NumberMarks","$Off","$OperatingSystem","$Output","$OutputForms","$OutputSizeLimit","$OutputStreamMethods","$Packages","$ParentLink","$ParentProcessID","$PasswordFile","$PatchLevelID","$Path","$PathnameSeparator","$PerformanceGoal","$Permissions","$PermissionsGroupBase","$PersistenceBase","$PersistencePath","$PipeSupported","$PlotTheme","$Post","$Pre","$PreferencesDirectory","$PreInitialization","$PrePrint","$PreRead","$PrintForms","$PrintLiteral","$Printout3DPreviewer","$ProcessID","$ProcessorCount","$ProcessorType","$ProductInformation","$ProgramName","$PublisherID","$RandomState","$RecursionLimit","$RegisteredDeviceClasses","$RegisteredUserName","$ReleaseNumber","$RequesterAddress","$RequesterWolframID","$RequesterWolframUUID","$RootDirectory","$ScheduledTask","$ScriptCommandLine","$ScriptInputString","$SecuredAuthenticationKeyTokens","$ServiceCreditsAvailable","$Services","$SessionID","$SetParentLink","$SharedFunctions","$SharedVariables","$SoundDisplay","$SoundDisplayFunction","$SourceLink","$SSHAuthentication","$SubtitleDecoders","$SubtitleEncoders","$SummaryBoxDataSizeLimit","$SuppressInputFormHeads","$SynchronousEvaluation","$SyntaxHandler","$System","$SystemCharacterEncoding","$SystemCredentialStore","$SystemID","$SystemMemory","$SystemShell","$SystemTimeZone","$SystemWordLength","$TemplatePath","$TemporaryDirectory","$TemporaryPrefix","$TestFileName","$TextStyle","$TimedOut","$TimeUnit","$TimeZone","$TimeZoneEntity","$TopDirectory","$TraceOff","$TraceOn","$TracePattern","$TracePostAction","$TracePreAction","$UnitSystem","$Urgent","$UserAddOnsDirectory","$UserAgentLanguages","$UserAgentMachine","$UserAgentName","$UserAgentOperatingSystem","$UserAgentString","$UserAgentVersion","$UserBaseDirectory","$UserBasePacletsDirectory","$UserDocumentsDirectory","$Username","$UserName","$UserURLBase","$Version","$VersionNumber","$VideoDecoders","$VideoEncoders","$VoiceStyles","$WolframDocumentsDirectory","$WolframID","$WolframUUID"]
;return t=>{
const i=t.regex,o=i.either(i.concat(/([2-9]|[1-2]\d|[3][0-5])\^\^/,/(\w*\.\w+|\w+\.\w*|\w+)/),/(\d*\.\d+|\d+\.\d*|\d+)/),a=i.either(/``[+-]?(\d*\.\d+|\d+\.\d*|\d+)/,/`([+-]?(\d*\.\d+|\d+\.\d*|\d+))?/),n={
className:"number",relevance:0,
begin:i.concat(o,i.optional(a),i.optional(/\*\^[+-]?\d+/))
},r=/[a-zA-Z$][a-zA-Z0-9$]*/,l=new Set(e),s={variants:[{
className:"builtin-symbol",begin:r,"on:begin":(e,t)=>{
l.has(e[0])||t.ignoreMatch()}},{className:"symbol",relevance:0,begin:r}]},c={
className:"message-name",relevance:0,begin:i.concat("::",r)};return{
name:"Mathematica",aliases:["mma","wl"],classNameAliases:{brace:"punctuation",
pattern:"type",slot:"type",symbol:"variable","named-character":"variable",
"builtin-symbol":"built_in","message-name":"string"},
contains:[t.COMMENT(/\(\*/,/\*\)/,{contains:["self"]}),{className:"pattern",
relevance:0,begin:/([a-zA-Z$][a-zA-Z0-9$]*)?_+([a-zA-Z$][a-zA-Z0-9$]*)?/},{
className:"slot",relevance:0,begin:/#[a-zA-Z$][a-zA-Z0-9$]*|#+[0-9]?/},c,s,{
className:"named-character",begin:/\\\[[$a-zA-Z][$a-zA-Z0-9]+\]/
},t.QUOTE_STRING_MODE,n,{className:"operator",relevance:0,
begin:/[+\-*/,;.:@~=><&|_`'^?!%]+/},{className:"brace",relevance:0,
begin:/[[\](){}]/}]}}})();hljs.registerLanguage("mathematica",e)})();/*! `verilog` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{
const n=e.regex,t=["begin_keywords","celldefine","default_nettype","default_decay_time","default_trireg_strength","define","delay_mode_distributed","delay_mode_path","delay_mode_unit","delay_mode_zero","else","elsif","end_keywords","endcelldefine","endif","ifdef","ifndef","include","line","nounconnected_drive","pragma","resetall","timescale","unconnected_drive","undef","undefineall"]
;return{name:"Verilog",aliases:["v","sv","svh"],case_insensitive:!1,keywords:{
$pattern:/\$?[\w]+(\$[\w]+)*/,
keyword:["accept_on","alias","always","always_comb","always_ff","always_latch","and","assert","assign","assume","automatic","before","begin","bind","bins","binsof","bit","break","buf|0","bufif0","bufif1","byte","case","casex","casez","cell","chandle","checker","class","clocking","cmos","config","const","constraint","context","continue","cover","covergroup","coverpoint","cross","deassign","default","defparam","design","disable","dist","do","edge","else","end","endcase","endchecker","endclass","endclocking","endconfig","endfunction","endgenerate","endgroup","endinterface","endmodule","endpackage","endprimitive","endprogram","endproperty","endspecify","endsequence","endtable","endtask","enum","event","eventually","expect","export","extends","extern","final","first_match","for","force","foreach","forever","fork","forkjoin","function","generate|5","genvar","global","highz0","highz1","if","iff","ifnone","ignore_bins","illegal_bins","implements","implies","import","incdir","include","initial","inout","input","inside","instance","int","integer","interconnect","interface","intersect","join","join_any","join_none","large","let","liblist","library","local","localparam","logic","longint","macromodule","matches","medium","modport","module","nand","negedge","nettype","new","nexttime","nmos","nor","noshowcancelled","not","notif0","notif1","or","output","package","packed","parameter","pmos","posedge","primitive","priority","program","property","protected","pull0","pull1","pulldown","pullup","pulsestyle_ondetect","pulsestyle_onevent","pure","rand","randc","randcase","randsequence","rcmos","real","realtime","ref","reg","reject_on","release","repeat","restrict","return","rnmos","rpmos","rtran","rtranif0","rtranif1","s_always","s_eventually","s_nexttime","s_until","s_until_with","scalared","sequence","shortint","shortreal","showcancelled","signed","small","soft","solve","specify","specparam","static","string","strong","strong0","strong1","struct","super","supply0","supply1","sync_accept_on","sync_reject_on","table","tagged","task","this","throughout","time","timeprecision","timeunit","tran","tranif0","tranif1","tri","tri0","tri1","triand","trior","trireg","type","typedef","union","unique","unique0","unsigned","until","until_with","untyped","use","uwire","var","vectored","virtual","void","wait","wait_order","wand","weak","weak0","weak1","while","wildcard","wire","with","within","wor","xnor","xor"],
literal:["null"],
built_in:["$finish","$stop","$exit","$fatal","$error","$warning","$info","$realtime","$time","$printtimescale","$bitstoreal","$bitstoshortreal","$itor","$signed","$cast","$bits","$stime","$timeformat","$realtobits","$shortrealtobits","$rtoi","$unsigned","$asserton","$assertkill","$assertpasson","$assertfailon","$assertnonvacuouson","$assertoff","$assertcontrol","$assertpassoff","$assertfailoff","$assertvacuousoff","$isunbounded","$sampled","$fell","$changed","$past_gclk","$fell_gclk","$changed_gclk","$rising_gclk","$steady_gclk","$coverage_control","$coverage_get","$coverage_save","$set_coverage_db_name","$rose","$stable","$past","$rose_gclk","$stable_gclk","$future_gclk","$falling_gclk","$changing_gclk","$display","$coverage_get_max","$coverage_merge","$get_coverage","$load_coverage_db","$typename","$unpacked_dimensions","$left","$low","$increment","$clog2","$ln","$log10","$exp","$sqrt","$pow","$floor","$ceil","$sin","$cos","$tan","$countbits","$onehot","$isunknown","$fatal","$warning","$dimensions","$right","$high","$size","$asin","$acos","$atan","$atan2","$hypot","$sinh","$cosh","$tanh","$asinh","$acosh","$atanh","$countones","$onehot0","$error","$info","$random","$dist_chi_square","$dist_erlang","$dist_exponential","$dist_normal","$dist_poisson","$dist_t","$dist_uniform","$q_initialize","$q_remove","$q_exam","$async$and$array","$async$nand$array","$async$or$array","$async$nor$array","$sync$and$array","$sync$nand$array","$sync$or$array","$sync$nor$array","$q_add","$q_full","$psprintf","$async$and$plane","$async$nand$plane","$async$or$plane","$async$nor$plane","$sync$and$plane","$sync$nand$plane","$sync$or$plane","$sync$nor$plane","$system","$display","$displayb","$displayh","$displayo","$strobe","$strobeb","$strobeh","$strobeo","$write","$readmemb","$readmemh","$writememh","$value$plusargs","$dumpvars","$dumpon","$dumplimit","$dumpports","$dumpportson","$dumpportslimit","$writeb","$writeh","$writeo","$monitor","$monitorb","$monitorh","$monitoro","$writememb","$dumpfile","$dumpoff","$dumpall","$dumpflush","$dumpportsoff","$dumpportsall","$dumpportsflush","$fclose","$fdisplay","$fdisplayb","$fdisplayh","$fdisplayo","$fstrobe","$fstrobeb","$fstrobeh","$fstrobeo","$swrite","$swriteb","$swriteh","$swriteo","$fscanf","$fread","$fseek","$fflush","$feof","$fopen","$fwrite","$fwriteb","$fwriteh","$fwriteo","$fmonitor","$fmonitorb","$fmonitorh","$fmonitoro","$sformat","$sformatf","$fgetc","$ungetc","$fgets","$sscanf","$rewind","$ftell","$ferror"]
},contains:[e.C_BLOCK_COMMENT_MODE,e.C_LINE_COMMENT_MODE,e.QUOTE_STRING_MODE,{
scope:"number",contains:[e.BACKSLASH_ESCAPE],variants:[{
begin:/\b((\d+'([bhodBHOD]))[0-9xzXZa-fA-F_]+)/},{
begin:/\B(('([bhodBHOD]))[0-9xzXZa-fA-F_]+)/},{begin:/\b[0-9][0-9_]*/,
relevance:0}]},{scope:"variable",variants:[{begin:"#\\((?!parameter).+\\)"},{
begin:"\\.\\w+",relevance:0}]},{scope:"variable.constant",
match:n.concat(/`/,n.either("__FILE__","__LINE__"))},{scope:"meta",
begin:n.concat(/`/,n.either(...t)),end:/$|\/\/|\/\*/,returnEnd:!0,keywords:t}]}}
})();hljs.registerLanguage("verilog",e)})();/*! `coq` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>({name:"Coq",keywords:{
keyword:["_|0","as","at","cofix","else","end","exists","exists2","fix","for","forall","fun","if","IF","in","let","match","mod","Prop","return","Set","then","Type","using","where","with","Abort","About","Add","Admit","Admitted","All","Arguments","Assumptions","Axiom","Back","BackTo","Backtrack","Bind","Blacklist","Canonical","Cd","Check","Class","Classes","Close","Coercion","Coercions","CoFixpoint","CoInductive","Collection","Combined","Compute","Conjecture","Conjectures","Constant","constr","Constraint","Constructors","Context","Corollary","CreateHintDb","Cut","Declare","Defined","Definition","Delimit","Dependencies","Dependent","Derive","Drop","eauto","End","Equality","Eval","Example","Existential","Existentials","Existing","Export","exporting","Extern","Extract","Extraction","Fact","Field","Fields","File","Fixpoint","Focus","for","From","Function","Functional","Generalizable","Global","Goal","Grab","Grammar","Graph","Guarded","Heap","Hint","HintDb","Hints","Hypotheses","Hypothesis","ident","Identity","If","Immediate","Implicit","Import","Include","Inductive","Infix","Info","Initial","Inline","Inspect","Instance","Instances","Intro","Intros","Inversion","Inversion_clear","Language","Left","Lemma","Let","Libraries","Library","Load","LoadPath","Local","Locate","Ltac","ML","Mode","Module","Modules","Monomorphic","Morphism","Next","NoInline","Notation","Obligation","Obligations","Opaque","Open","Optimize","Options","Parameter","Parameters","Parametric","Path","Paths","pattern","Polymorphic","Preterm","Print","Printing","Program","Projections","Proof","Proposition","Pwd","Qed","Quit","Rec","Record","Recursive","Redirect","Relation","Remark","Remove","Require","Reserved","Reset","Resolve","Restart","Rewrite","Right","Ring","Rings","Save","Scheme","Scope","Scopes","Script","Search","SearchAbout","SearchHead","SearchPattern","SearchRewrite","Section","Separate","Set","Setoid","Show","Solve","Sorted","Step","Strategies","Strategy","Structure","SubClass","Table","Tables","Tactic","Term","Test","Theorem","Time","Timeout","Transparent","Type","Typeclasses","Types","Undelimit","Undo","Unfocus","Unfocused","Unfold","Universe","Universes","Unset","Unshelve","using","Variable","Variables","Variant","Verbose","Visibility","where","with"],
built_in:["abstract","absurd","admit","after","apply","as","assert","assumption","at","auto","autorewrite","autounfold","before","bottom","btauto","by","case","case_eq","cbn","cbv","change","classical_left","classical_right","clear","clearbody","cofix","compare","compute","congruence","constr_eq","constructor","contradict","contradiction","cut","cutrewrite","cycle","decide","decompose","dependent","destruct","destruction","dintuition","discriminate","discrR","do","double","dtauto","eapply","eassumption","eauto","ecase","econstructor","edestruct","ediscriminate","eelim","eexact","eexists","einduction","einjection","eleft","elim","elimtype","enough","equality","erewrite","eright","esimplify_eq","esplit","evar","exact","exactly_once","exfalso","exists","f_equal","fail","field","field_simplify","field_simplify_eq","first","firstorder","fix","fold","fourier","functional","generalize","generalizing","gfail","give_up","has_evar","hnf","idtac","in","induction","injection","instantiate","intro","intro_pattern","intros","intuition","inversion","inversion_clear","is_evar","is_var","lapply","lazy","left","lia","lra","move","native_compute","nia","nsatz","omega","once","pattern","pose","progress","proof","psatz","quote","record","red","refine","reflexivity","remember","rename","repeat","replace","revert","revgoals","rewrite","rewrite_strat","right","ring","ring_simplify","rtauto","set","setoid_reflexivity","setoid_replace","setoid_rewrite","setoid_symmetry","setoid_transitivity","shelve","shelve_unifiable","simpl","simple","simplify_eq","solve","specialize","split","split_Rabs","split_Rmult","stepl","stepr","subst","sum","swap","symmetry","tactic","tauto","time","timeout","top","transitivity","trivial","try","tryif","unfold","unify","until","using","vm_compute","with"]
},contains:[e.QUOTE_STRING_MODE,e.COMMENT("\\(\\*","\\*\\)"),e.C_NUMBER_MODE,{
className:"type",excludeBegin:!0,begin:"\\|\\s*",end:"\\w+"},{begin:/[-=]>/}]})
})();hljs.registerLanguage("coq",e)})();/*! `prolog` grammar compiled for Highlight.js 11.5.1 */
(()=>{var n=(()=>{"use strict";return n=>{const e={begin:/\(/,end:/\)/,
relevance:0},a={begin:/\[/,end:/\]/},s={className:"comment",begin:/%/,end:/$/,
contains:[n.PHRASAL_WORDS_MODE]},i={className:"string",begin:/`/,end:/`/,
contains:[n.BACKSLASH_ESCAPE]},g=[{begin:/[a-z][A-Za-z0-9_]*/,relevance:0},{
className:"symbol",variants:[{begin:/[A-Z][a-zA-Z0-9_]*/},{
begin:/_[A-Za-z0-9_]*/}],relevance:0},e,{begin:/:-/
},a,s,n.C_BLOCK_COMMENT_MODE,n.QUOTE_STRING_MODE,n.APOS_STRING_MODE,i,{
className:"string",begin:/0'(\\'|.)/},{className:"string",begin:/0'\\s/
},n.C_NUMBER_MODE];return e.contains=g,a.contains=g,{name:"Prolog",
contains:g.concat([{begin:/\.$/}])}}})();hljs.registerLanguage("prolog",n)})();/*! `sml` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>({name:"SML (Standard ML)",
aliases:["ml"],keywords:{$pattern:"[a-z_]\\w*!?",
keyword:"abstype and andalso as case datatype do else end eqtype exception fn fun functor handle if in include infix infixr let local nonfix of op open orelse raise rec sharing sig signature struct structure then type val with withtype where while",
built_in:"array bool char exn int list option order real ref string substring vector unit word",
literal:"true false NONE SOME LESS EQUAL GREATER nil"},illegal:/\/\/|>>/,
contains:[{className:"literal",begin:/\[(\|\|)?\]|\(\)/,relevance:0
},e.COMMENT("\\(\\*","\\*\\)",{contains:["self"]}),{className:"symbol",
begin:"'[A-Za-z_](?!')[\\w']*"},{className:"type",begin:"`[A-Z][\\w']*"},{
className:"type",begin:"\\b[A-Z][\\w']*",relevance:0},{
begin:"[a-z_]\\w*'[\\w']*"},e.inherit(e.APOS_STRING_MODE,{className:"string",
relevance:0}),e.inherit(e.QUOTE_STRING_MODE,{illegal:null}),{className:"number",
begin:"\\b(0[xX][a-fA-F0-9_]+[Lln]?|0[oO][0-7_]+[Lln]?|0[bB][01_]+[Lln]?|[0-9][0-9_]*([Lln]|(\\.[0-9_]*)?([eE][-+]?[0-9_]+)?)?)",
relevance:0},{begin:/[-=]>/}]})})();hljs.registerLanguage("sml",e)})();/*! `dockerfile` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>({name:"Dockerfile",aliases:["docker"],
case_insensitive:!0,
keywords:["from","maintainer","expose","env","arg","user","onbuild","stopsignal"],
contains:[e.HASH_COMMENT_MODE,e.APOS_STRING_MODE,e.QUOTE_STRING_MODE,e.NUMBER_MODE,{
beginKeywords:"run cmd entrypoint volume add copy workdir label healthcheck shell",
starts:{end:/[^\\]$/,subLanguage:"bash"}}],illegal:"</"})})()
;hljs.registerLanguage("dockerfile",e)})();/*! `kotlin` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict"
;var e="\\.([0-9](_*[0-9])*)",n="[0-9a-fA-F](_*[0-9a-fA-F])*",a={
className:"number",variants:[{
begin:`(\\b([0-9](_*[0-9])*)((${e})|\\.)?|(${e}))[eE][+-]?([0-9](_*[0-9])*)[fFdD]?\\b`
},{begin:`\\b([0-9](_*[0-9])*)((${e})[fFdD]?\\b|\\.([fFdD]\\b)?)`},{
begin:`(${e})[fFdD]?\\b`},{begin:"\\b([0-9](_*[0-9])*)[fFdD]\\b"},{
begin:`\\b0[xX]((${n})\\.?|(${n})?\\.(${n}))[pP][+-]?([0-9](_*[0-9])*)[fFdD]?\\b`
},{begin:"\\b(0|[1-9](_*[0-9])*)[lL]?\\b"},{begin:`\\b0[xX](${n})[lL]?\\b`},{
begin:"\\b0(_*[0-7])*[lL]?\\b"},{begin:"\\b0[bB][01](_*[01])*[lL]?\\b"}],
relevance:0};return e=>{const n={
keyword:"abstract as val var vararg get set class object open private protected public noinline crossinline dynamic final enum if else do while for when throw try catch finally import package is in fun override companion reified inline lateinit init interface annotation data sealed internal infix operator out by constructor super tailrec where const inner suspend typealias external expect actual",
built_in:"Byte Short Char Int Long Boolean Float Double Void Unit Nothing",
literal:"true false null"},i={className:"symbol",begin:e.UNDERSCORE_IDENT_RE+"@"
},s={className:"subst",begin:/\$\{/,end:/\}/,contains:[e.C_NUMBER_MODE]},t={
className:"variable",begin:"\\$"+e.UNDERSCORE_IDENT_RE},r={className:"string",
variants:[{begin:'"""',end:'"""(?=[^"])',contains:[t,s]},{begin:"'",end:"'",
illegal:/\n/,contains:[e.BACKSLASH_ESCAPE]},{begin:'"',end:'"',illegal:/\n/,
contains:[e.BACKSLASH_ESCAPE,t,s]}]};s.contains.push(r);const l={
className:"meta",
begin:"@(?:file|property|field|get|set|receiver|param|setparam|delegate)\\s*:(?:\\s*"+e.UNDERSCORE_IDENT_RE+")?"
},c={className:"meta",begin:"@"+e.UNDERSCORE_IDENT_RE,contains:[{begin:/\(/,
end:/\)/,contains:[e.inherit(r,{className:"string"})]}]
},o=a,b=e.COMMENT("/\\*","\\*/",{contains:[e.C_BLOCK_COMMENT_MODE]}),E={
variants:[{className:"type",begin:e.UNDERSCORE_IDENT_RE},{begin:/\(/,end:/\)/,
contains:[]}]},d=E;return d.variants[1].contains=[E],E.variants[1].contains=[d],
{name:"Kotlin",aliases:["kt","kts"],keywords:n,
contains:[e.COMMENT("/\\*\\*","\\*/",{relevance:0,contains:[{className:"doctag",
begin:"@[A-Za-z]+"}]}),e.C_LINE_COMMENT_MODE,b,{className:"keyword",
begin:/\b(break|continue|return|this)\b/,starts:{contains:[{className:"symbol",
begin:/@\w+/}]}},i,l,c,{className:"function",beginKeywords:"fun",end:"[(]|$",
returnBegin:!0,excludeEnd:!0,keywords:n,relevance:5,contains:[{
begin:e.UNDERSCORE_IDENT_RE+"\\s*\\(",returnBegin:!0,relevance:0,
contains:[e.UNDERSCORE_TITLE_MODE]},{className:"type",begin:/</,end:/>/,
keywords:"reified",relevance:0},{className:"params",begin:/\(/,end:/\)/,
endsParent:!0,keywords:n,relevance:0,contains:[{begin:/:/,end:/[=,\/]/,
endsWithParent:!0,contains:[E,e.C_LINE_COMMENT_MODE,b],relevance:0
},e.C_LINE_COMMENT_MODE,b,l,c,r,e.C_NUMBER_MODE]},b]},{className:"class",
beginKeywords:"class interface trait",end:/[:\{(]|$/,excludeEnd:!0,
illegal:"extends implements",contains:[{
beginKeywords:"public protected internal private constructor"
},e.UNDERSCORE_TITLE_MODE,{className:"type",begin:/</,end:/>/,excludeBegin:!0,
excludeEnd:!0,relevance:0},{className:"type",begin:/[,:]\s*/,end:/[<\(,]|$/,
excludeBegin:!0,returnEnd:!0},l,c]},r,{className:"meta",begin:"^#!/usr/bin/env",
end:"$",illegal:"\n"},o]}}})();hljs.registerLanguage("kotlin",e)})();/*! `makefile` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{const i={className:"variable",
variants:[{begin:"\\$\\("+e.UNDERSCORE_IDENT_RE+"\\)",
contains:[e.BACKSLASH_ESCAPE]},{begin:/\$[@%<?\^\+\*]/}]},a={className:"string",
begin:/"/,end:/"/,contains:[e.BACKSLASH_ESCAPE,i]},n={className:"variable",
begin:/\$\([\w-]+\s/,end:/\)/,keywords:{
built_in:"subst patsubst strip findstring filter filter-out sort word wordlist firstword lastword dir notdir suffix basename addsuffix addprefix join wildcard realpath abspath error warning shell origin flavor foreach if or and call eval file value"
},contains:[i]},s={begin:"^"+e.UNDERSCORE_IDENT_RE+"\\s*(?=[:+?]?=)"},r={
className:"section",begin:/^[^\s]+:/,end:/$/,contains:[i]};return{
name:"Makefile",aliases:["mk","mak","make"],keywords:{$pattern:/[\w-]+/,
keyword:"define endef undefine ifdef ifndef ifeq ifneq else endif include -include sinclude override export unexport private vpath"
},contains:[e.HASH_COMMENT_MODE,i,a,n,s,{className:"meta",begin:/^\.PHONY:/,
end:/$/,keywords:{$pattern:/[\.\w]+/,keyword:".PHONY"}},r]}}})()
;hljs.registerLanguage("makefile",e)})();/*! `erlang` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{
const n="[a-z'][a-zA-Z0-9_']*",r="("+n+":"+n+"|"+n+")",a={
keyword:"after and andalso|10 band begin bnot bor bsl bzr bxor case catch cond div end fun if let not of orelse|10 query receive rem try when xor",
literal:"false true"},i=e.COMMENT("%","$"),s={className:"number",
begin:"\\b(\\d+(_\\d+)*#[a-fA-F0-9]+(_[a-fA-F0-9]+)*|\\d+(_\\d+)*(\\.\\d+(_\\d+)*)?([eE][-+]?\\d+)?)",
relevance:0},c={begin:"fun\\s+"+n+"/\\d+"},t={begin:r+"\\(",end:"\\)",
returnBegin:!0,relevance:0,contains:[{begin:r,relevance:0},{begin:"\\(",
end:"\\)",endsWithParent:!0,returnEnd:!0,relevance:0}]},d={begin:/\{/,end:/\}/,
relevance:0},o={begin:"\\b_([A-Z][A-Za-z0-9_]*)?",relevance:0},l={
begin:"[A-Z][a-zA-Z0-9_]*",relevance:0},b={begin:"#"+e.UNDERSCORE_IDENT_RE,
relevance:0,returnBegin:!0,contains:[{begin:"#"+e.UNDERSCORE_IDENT_RE,
relevance:0},{begin:/\{/,end:/\}/,relevance:0}]},g={
beginKeywords:"fun receive if try case",end:"end",keywords:a}
;g.contains=[i,c,e.inherit(e.APOS_STRING_MODE,{className:""
}),g,t,e.QUOTE_STRING_MODE,s,d,o,l,b]
;const E=[i,c,g,t,e.QUOTE_STRING_MODE,s,d,o,l,b]
;t.contains[1].contains=E,d.contains=E,b.contains[1].contains=E;const u={
className:"params",begin:"\\(",end:"\\)",contains:E};return{name:"Erlang",
aliases:["erl"],keywords:a,illegal:"(</|\\*=|\\+=|-=|/\\*|\\*/|\\(\\*|\\*\\))",
contains:[{className:"function",begin:"^"+n+"\\s*\\(",end:"->",returnBegin:!0,
illegal:"\\(|#|//|/\\*|\\\\|:|;",contains:[u,e.inherit(e.TITLE_MODE,{begin:n})],
starts:{end:";|\\.",keywords:a,contains:E}},i,{begin:"^-",end:"\\.",relevance:0,
excludeEnd:!0,returnBegin:!0,keywords:{$pattern:"-"+e.IDENT_RE,
keyword:["-module","-record","-undef","-export","-ifdef","-ifndef","-author","-copyright","-doc","-vsn","-import","-include","-include_lib","-compile","-define","-else","-endif","-file","-behaviour","-behavior","-spec"].map((e=>e+"|1.5")).join(" ")
},contains:[u]},s,e.QUOTE_STRING_MODE,b,o,l,d,{begin:/\.$/}]}}})()
;hljs.registerLanguage("erlang",e)})();/*! `crystal` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{
const n="(_?[ui](8|16|32|64|128))?",i="[a-zA-Z_]\\w*[!?=]?|[-+~]@|<<|>>|[=!]~|===?|<=>|[<>]=?|\\*\\*|[-/+%^&*~|]|//|//=|&[-+*]=?|&\\*\\*|\\[\\][=?]?",s="[A-Za-z_]\\w*(::\\w+)*(\\?|!)?",a={
$pattern:"[a-zA-Z_]\\w*[!?=]?",
keyword:"abstract alias annotation as as? asm begin break case class def do else elsif end ensure enum extend for fun if include instance_sizeof is_a? lib macro module next nil? of out pointerof private protected rescue responds_to? return require select self sizeof struct super then type typeof union uninitialized unless until verbatim when while with yield __DIR__ __END_LINE__ __FILE__ __LINE__",
literal:"false nil true"},t={className:"subst",begin:/#\{/,end:/\}/,keywords:a
},c={className:"template-variable",variants:[{begin:"\\{\\{",end:"\\}\\}"},{
begin:"\\{%",end:"%\\}"}],keywords:a};function r(e,n){const i=[{begin:e,end:n}]
;return i[0].contains=i,i}const l={className:"string",
contains:[e.BACKSLASH_ESCAPE,t],variants:[{begin:/'/,end:/'/},{begin:/"/,end:/"/
},{begin:/`/,end:/`/},{begin:"%[Qwi]?\\(",end:"\\)",contains:r("\\(","\\)")},{
begin:"%[Qwi]?\\[",end:"\\]",contains:r("\\[","\\]")},{begin:"%[Qwi]?\\{",
end:/\}/,contains:r(/\{/,/\}/)},{begin:"%[Qwi]?<",end:">",contains:r("<",">")},{
begin:"%[Qwi]?\\|",end:"\\|"},{begin:/<<-\w+$/,end:/^\s*\w+$/}],relevance:0},b={
className:"string",variants:[{begin:"%q\\(",end:"\\)",contains:r("\\(","\\)")},{
begin:"%q\\[",end:"\\]",contains:r("\\[","\\]")},{begin:"%q\\{",end:/\}/,
contains:r(/\{/,/\}/)},{begin:"%q<",end:">",contains:r("<",">")},{begin:"%q\\|",
end:"\\|"},{begin:/<<-'\w+'$/,end:/^\s*\w+$/}],relevance:0},o={
begin:"(?!%\\})("+e.RE_STARTERS_RE+"|\\n|\\b(case|if|select|unless|until|when|while)\\b)\\s*",
keywords:"case if select unless until when while",contains:[{className:"regexp",
contains:[e.BACKSLASH_ESCAPE,t],variants:[{begin:"//[a-z]*",relevance:0},{
begin:"/(?!\\/)",end:"/[a-z]*"}]}],relevance:0},g=[c,l,b,{className:"regexp",
contains:[e.BACKSLASH_ESCAPE,t],variants:[{begin:"%r\\(",end:"\\)",
contains:r("\\(","\\)")},{begin:"%r\\[",end:"\\]",contains:r("\\[","\\]")},{
begin:"%r\\{",end:/\}/,contains:r(/\{/,/\}/)},{begin:"%r<",end:">",
contains:r("<",">")},{begin:"%r\\|",end:"\\|"}],relevance:0},o,{
className:"meta",begin:"@\\[",end:"\\]",
contains:[e.inherit(e.QUOTE_STRING_MODE,{className:"string"})]},{
className:"variable",
begin:"(\\$\\W)|((\\$|@@?)(\\w+))(?=[^@$?])(?![A-Za-z])(?![@$?'])"
},e.HASH_COMMENT_MODE,{className:"class",beginKeywords:"class module struct",
end:"$|;",illegal:/=/,contains:[e.HASH_COMMENT_MODE,e.inherit(e.TITLE_MODE,{
begin:s}),{begin:"<"}]},{className:"class",beginKeywords:"lib enum union",
end:"$|;",illegal:/=/,contains:[e.HASH_COMMENT_MODE,e.inherit(e.TITLE_MODE,{
begin:s})]},{beginKeywords:"annotation",end:"$|;",illegal:/=/,
contains:[e.HASH_COMMENT_MODE,e.inherit(e.TITLE_MODE,{begin:s})],relevance:2},{
className:"function",beginKeywords:"def",end:/\B\b/,
contains:[e.inherit(e.TITLE_MODE,{begin:i,endsParent:!0})]},{
className:"function",beginKeywords:"fun macro",end:/\B\b/,
contains:[e.inherit(e.TITLE_MODE,{begin:i,endsParent:!0})],relevance:2},{
className:"symbol",begin:e.UNDERSCORE_IDENT_RE+"(!|\\?)?:",relevance:0},{
className:"symbol",begin:":",contains:[l,{begin:i}],relevance:0},{
className:"number",variants:[{begin:"\\b0b([01_]+)"+n},{begin:"\\b0o([0-7_]+)"+n
},{begin:"\\b0x([A-Fa-f0-9_]+)"+n},{
begin:"\\b([1-9][0-9_]*[0-9]|[0-9])(\\.[0-9][0-9_]*)?([eE]_?[-+]?[0-9_]*)?(_?f(32|64))?(?!_)"
},{begin:"\\b([1-9][0-9_]*|0)"+n}],relevance:0}]
;return t.contains=g,c.contains=g.slice(1),{name:"Crystal",aliases:["cr"],
keywords:a,contains:g}}})();hljs.registerLanguage("crystal",e)})();/*! `go` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{const n={
keyword:["break","case","chan","const","continue","default","defer","else","fallthrough","for","func","go","goto","if","import","interface","map","package","range","return","select","struct","switch","type","var"],
type:["bool","byte","complex64","complex128","error","float32","float64","int8","int16","int32","int64","string","uint8","uint16","uint32","uint64","int","uint","uintptr","rune"],
literal:["true","false","iota","nil"],
built_in:["append","cap","close","complex","copy","imag","len","make","new","panic","print","println","real","recover","delete"]
};return{name:"Go",aliases:["golang"],keywords:n,illegal:"</",
contains:[e.C_LINE_COMMENT_MODE,e.C_BLOCK_COMMENT_MODE,{className:"string",
variants:[e.QUOTE_STRING_MODE,e.APOS_STRING_MODE,{begin:"`",end:"`"}]},{
className:"number",variants:[{begin:e.C_NUMBER_RE+"[i]",relevance:1
},e.C_NUMBER_MODE]},{begin:/:=/},{className:"function",beginKeywords:"func",
end:"\\s*(\\{|$)",excludeEnd:!0,contains:[e.TITLE_MODE,{className:"params",
begin:/\(/,end:/\)/,endsParent:!0,keywords:n,illegal:/["']/}]}]}}})()
;hljs.registerLanguage("go",e)})();/*! `sql` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{
const r=e.regex,t=e.COMMENT("--","$"),n=["true","false","unknown"],a=["bigint","binary","blob","boolean","char","character","clob","date","dec","decfloat","decimal","float","int","integer","interval","nchar","nclob","national","numeric","real","row","smallint","time","timestamp","varchar","varying","varbinary"],i=["abs","acos","array_agg","asin","atan","avg","cast","ceil","ceiling","coalesce","corr","cos","cosh","count","covar_pop","covar_samp","cume_dist","dense_rank","deref","element","exp","extract","first_value","floor","json_array","json_arrayagg","json_exists","json_object","json_objectagg","json_query","json_table","json_table_primitive","json_value","lag","last_value","lead","listagg","ln","log","log10","lower","max","min","mod","nth_value","ntile","nullif","percent_rank","percentile_cont","percentile_disc","position","position_regex","power","rank","regr_avgx","regr_avgy","regr_count","regr_intercept","regr_r2","regr_slope","regr_sxx","regr_sxy","regr_syy","row_number","sin","sinh","sqrt","stddev_pop","stddev_samp","substring","substring_regex","sum","tan","tanh","translate","translate_regex","treat","trim","trim_array","unnest","upper","value_of","var_pop","var_samp","width_bucket"],s=["create table","insert into","primary key","foreign key","not null","alter table","add constraint","grouping sets","on overflow","character set","respect nulls","ignore nulls","nulls first","nulls last","depth first","breadth first"],o=i,c=["abs","acos","all","allocate","alter","and","any","are","array","array_agg","array_max_cardinality","as","asensitive","asin","asymmetric","at","atan","atomic","authorization","avg","begin","begin_frame","begin_partition","between","bigint","binary","blob","boolean","both","by","call","called","cardinality","cascaded","case","cast","ceil","ceiling","char","char_length","character","character_length","check","classifier","clob","close","coalesce","collate","collect","column","commit","condition","connect","constraint","contains","convert","copy","corr","corresponding","cos","cosh","count","covar_pop","covar_samp","create","cross","cube","cume_dist","current","current_catalog","current_date","current_default_transform_group","current_path","current_role","current_row","current_schema","current_time","current_timestamp","current_path","current_role","current_transform_group_for_type","current_user","cursor","cycle","date","day","deallocate","dec","decimal","decfloat","declare","default","define","delete","dense_rank","deref","describe","deterministic","disconnect","distinct","double","drop","dynamic","each","element","else","empty","end","end_frame","end_partition","end-exec","equals","escape","every","except","exec","execute","exists","exp","external","extract","false","fetch","filter","first_value","float","floor","for","foreign","frame_row","free","from","full","function","fusion","get","global","grant","group","grouping","groups","having","hold","hour","identity","in","indicator","initial","inner","inout","insensitive","insert","int","integer","intersect","intersection","interval","into","is","join","json_array","json_arrayagg","json_exists","json_object","json_objectagg","json_query","json_table","json_table_primitive","json_value","lag","language","large","last_value","lateral","lead","leading","left","like","like_regex","listagg","ln","local","localtime","localtimestamp","log","log10","lower","match","match_number","match_recognize","matches","max","member","merge","method","min","minute","mod","modifies","module","month","multiset","national","natural","nchar","nclob","new","no","none","normalize","not","nth_value","ntile","null","nullif","numeric","octet_length","occurrences_regex","of","offset","old","omit","on","one","only","open","or","order","out","outer","over","overlaps","overlay","parameter","partition","pattern","per","percent","percent_rank","percentile_cont","percentile_disc","period","portion","position","position_regex","power","precedes","precision","prepare","primary","procedure","ptf","range","rank","reads","real","recursive","ref","references","referencing","regr_avgx","regr_avgy","regr_count","regr_intercept","regr_r2","regr_slope","regr_sxx","regr_sxy","regr_syy","release","result","return","returns","revoke","right","rollback","rollup","row","row_number","rows","running","savepoint","scope","scroll","search","second","seek","select","sensitive","session_user","set","show","similar","sin","sinh","skip","smallint","some","specific","specifictype","sql","sqlexception","sqlstate","sqlwarning","sqrt","start","static","stddev_pop","stddev_samp","submultiset","subset","substring","substring_regex","succeeds","sum","symmetric","system","system_time","system_user","table","tablesample","tan","tanh","then","time","timestamp","timezone_hour","timezone_minute","to","trailing","translate","translate_regex","translation","treat","trigger","trim","trim_array","true","truncate","uescape","union","unique","unknown","unnest","update","upper","user","using","value","values","value_of","var_pop","var_samp","varbinary","varchar","varying","versioning","when","whenever","where","width_bucket","window","with","within","without","year","add","asc","collation","desc","final","first","last","view"].filter((e=>!i.includes(e))),l={
begin:r.concat(/\b/,r.either(...o),/\s*\(/),relevance:0,keywords:{built_in:o}}
;return{name:"SQL",case_insensitive:!0,illegal:/[{}]|<\//,keywords:{
$pattern:/\b[\w\.]+/,keyword:((e,{exceptions:r,when:t}={})=>{const n=t
;return r=r||[],e.map((e=>e.match(/\|\d+$/)||r.includes(e)?e:n(e)?e+"|0":e))
})(c,{when:e=>e.length<3}),literal:n,type:a,
built_in:["current_catalog","current_date","current_default_transform_group","current_path","current_role","current_schema","current_transform_group_for_type","current_user","session_user","system_time","system_user","current_time","localtime","current_timestamp","localtimestamp"]
},contains:[{begin:r.either(...s),relevance:0,keywords:{$pattern:/[\w\.]+/,
keyword:c.concat(s),literal:n,type:a}},{className:"type",
begin:r.either("double precision","large object","with timezone","without timezone")
},l,{className:"variable",begin:/@[a-z0-9]+/},{className:"string",variants:[{
begin:/'/,end:/'/,contains:[{begin:/''/}]}]},{begin:/"/,end:/"/,contains:[{
begin:/""/}]},e.C_NUMBER_MODE,e.C_BLOCK_COMMENT_MODE,t,{className:"operator",
begin:/[-+*/=%^~]|&&?|\|\|?|!=?|<(?:=>?|<|>)?|>[>=]?/,relevance:0}]}}})()
;hljs.registerLanguage("sql",e)})();/*! `fsharp` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";function e(e){
return RegExp(e.replace(/[-/\\^$*+?.()|[\]{}]/g,"\\$&"),"m")}function n(e){
return e?"string"==typeof e?e:e.source:null}function t(e){return i("(?=",e,")")}
function i(...e){return e.map((e=>n(e))).join("")}function a(...e){const t=(e=>{
const n=e[e.length-1]
;return"object"==typeof n&&n.constructor===Object?(e.splice(e.length-1,1),n):{}
})(e);return"("+(t.capture?"":"?:")+e.map((e=>n(e))).join("|")+")"}return n=>{
const r={scope:"keyword",match:/\b(yield|return|let|do|match|use)!/
},o=["bool","byte","sbyte","int8","int16","int32","uint8","uint16","uint32","int","uint","int64","uint64","nativeint","unativeint","decimal","float","double","float32","single","char","string","unit","bigint","option","voption","list","array","seq","byref","exn","inref","nativeptr","obj","outref","voidptr","Result"],s={
keyword:["abstract","and","as","assert","base","begin","class","default","delegate","do","done","downcast","downto","elif","else","end","exception","extern","finally","fixed","for","fun","function","global","if","in","inherit","inline","interface","internal","lazy","let","match","member","module","mutable","namespace","new","of","open","or","override","private","public","rec","return","static","struct","then","to","try","type","upcast","use","val","void","when","while","with","yield"],
literal:["true","false","null","Some","None","Ok","Error","infinity","infinityf","nan","nanf"],
built_in:["not","ref","raise","reraise","dict","readOnlyDict","set","get","enum","sizeof","typeof","typedefof","nameof","nullArg","invalidArg","invalidOp","id","fst","snd","ignore","lock","using","box","unbox","tryUnbox","printf","printfn","sprintf","eprintf","eprintfn","fprintf","fprintfn","failwith","failwithf"],
"variable.constant":["__LINE__","__SOURCE_DIRECTORY__","__SOURCE_FILE__"]},c={
variants:[n.COMMENT(/\(\*(?!\))/,/\*\)/,{contains:["self"]
}),n.C_LINE_COMMENT_MODE]},l={scope:"variable",begin:/``/,end:/``/
},u=/\B('|\^)/,p={scope:"symbol",variants:[{match:i(u,/``.*?``/)},{
match:i(u,n.UNDERSCORE_IDENT_RE)}],relevance:0},f=({includeEqual:n})=>{let r
;r=n?"!%&*+-/<=>@^|~?":"!%&*+-/<>@^|~?"
;const o=i("[",...Array.from(r).map(e),"]"),s=a(o,/\./),c=i(s,t(s)),l=a(i(c,s,"*"),i(o,"+"))
;return{scope:"operator",match:a(l,/:\?>/,/:\?/,/:>/,/:=/,/::?/,/\$/),
relevance:0}},d=f({includeEqual:!0}),b=f({includeEqual:!1}),g=(e,r)=>({
begin:i(e,t(i(/\s*/,a(/\w/,/'/,/\^/,/#/,/``/,/\(/,/{\|/)))),beginScope:r,
end:t(a(/\n/,/=/)),relevance:0,keywords:n.inherit(s,{type:o}),
contains:[c,p,n.inherit(l,{scope:null}),b]
}),m=g(/:/,"operator"),h=g(/\bof\b/,"keyword"),y={
begin:[/(^|\s+)/,/type/,/\s+/,/[a-zA-Z_](\w|')*/],beginScope:{2:"keyword",
4:"title.class"},end:t(/\(|=|$/),keywords:s,contains:[c,n.inherit(l,{scope:null
}),p,{scope:"operator",match:/<|>/},m]},E={scope:"computation-expression",
match:/\b[_a-z]\w*(?=\s*\{)/},_={
begin:[/^\s*/,i(/#/,a("if","else","endif","line","nowarn","light","r","i","I","load","time","help","quit")),/\b/],
beginScope:{2:"meta"},end:t(/\s|$/)},v={
variants:[n.BINARY_NUMBER_MODE,n.C_NUMBER_MODE]},w={scope:"string",begin:/"/,
end:/"/,contains:[n.BACKSLASH_ESCAPE]},A={scope:"string",begin:/@"/,end:/"/,
contains:[{match:/""/},n.BACKSLASH_ESCAPE]},S={scope:"string",begin:/"""/,
end:/"""/,relevance:2},C={scope:"subst",begin:/\{/,end:/\}/,keywords:s},O={
scope:"string",begin:/\$"/,end:/"/,contains:[{match:/\{\{/},{match:/\}\}/
},n.BACKSLASH_ESCAPE,C]},R={scope:"string",begin:/(\$@|@\$)"/,end:/"/,
contains:[{match:/\{\{/},{match:/\}\}/},{match:/""/},n.BACKSLASH_ESCAPE,C]},k={
scope:"string",begin:/\$"""/,end:/"""/,contains:[{match:/\{\{/},{match:/\}\}/
},C],relevance:2},x={scope:"string",
match:i(/'/,a(/[^\\']/,/\\(?:.|\d{3}|x[a-fA-F\d]{2}|u[a-fA-F\d]{4}|U[a-fA-F\d]{8})/),/'/)
};return C.contains=[R,O,A,w,x,r,c,l,m,E,_,v,p,d],{name:"F#",
aliases:["fs","f#"],keywords:s,illegal:/\/\*/,classNameAliases:{
"computation-expression":"keyword"},contains:[r,{variants:[k,R,O,S,A,w,x]
},c,l,y,{scope:"meta",begin:/\[</,end:/>\]/,relevance:2,contains:[l,S,A,w,x,v]
},h,m,E,_,v,p,d]}}})();hljs.registerLanguage("fsharp",e)})();/*! `http` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{const n="HTTP/(2|1\\.[01])",a={
className:"attribute",
begin:e.regex.concat("^",/[A-Za-z][A-Za-z0-9-]*/,"(?=\\:\\s)"),starts:{
contains:[{className:"punctuation",begin:/: /,relevance:0,starts:{end:"$",
relevance:0}}]}},s=[a,{begin:"\\n\\n",starts:{subLanguage:[],endsWithParent:!0}
}];return{name:"HTTP",aliases:["https"],illegal:/\S/,contains:[{
begin:"^(?="+n+" \\d{3})",end:/$/,contains:[{className:"meta",begin:n},{
className:"number",begin:"\\b\\d{3}\\b"}],starts:{end:/\b\B/,illegal:/\S/,
contains:s}},{begin:"(?=^[A-Z]+ (.*?) "+n+"$)",end:/$/,contains:[{
className:"string",begin:" ",end:" ",excludeBegin:!0,excludeEnd:!0},{
className:"meta",begin:n},{className:"keyword",begin:"[A-Z]+"}],starts:{
end:/\b\B/,illegal:/\S/,contains:s}},e.inherit(a,{relevance:0})]}}})()
;hljs.registerLanguage("http",e)})();/*! `smalltalk` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{const n="[a-z][a-zA-Z0-9_]*",a={
className:"string",begin:"\\$.{1}"},s={className:"symbol",
begin:"#"+e.UNDERSCORE_IDENT_RE};return{name:"Smalltalk",aliases:["st"],
keywords:["self","super","nil","true","false","thisContext"],
contains:[e.COMMENT('"','"'),e.APOS_STRING_MODE,{className:"type",
begin:"\\b[A-Z][A-Za-z0-9_]*",relevance:0},{begin:n+":",relevance:0
},e.C_NUMBER_MODE,s,a,{begin:"\\|[ ]*"+n+"([ ]+"+n+")*[ ]*\\|",returnBegin:!0,
end:/\|/,illegal:/\S/,contains:[{begin:"(\\|[ ]*)?"+n}]},{begin:"#\\(",
end:"\\)",contains:[e.APOS_STRING_MODE,a,e.C_NUMBER_MODE,s]}]}}})()
;hljs.registerLanguage("smalltalk",e)})();/*! `diff` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{const a=e.regex;return{name:"Diff",
aliases:["patch"],contains:[{className:"meta",relevance:10,
match:a.either(/^@@ +-\d+,\d+ +\+\d+,\d+ +@@/,/^\*\*\* +\d+,\d+ +\*\*\*\*$/,/^--- +\d+,\d+ +----$/)
},{className:"comment",variants:[{
begin:a.either(/Index: /,/^index/,/={3,}/,/^-{3}/,/^\*{3} /,/^\+{3}/,/^diff --git/),
end:/$/},{match:/^\*{15}$/}]},{className:"addition",begin:/^\+/,end:/$/},{
className:"deletion",begin:/^-/,end:/$/},{className:"addition",begin:/^!/,
end:/$/}]}}})();hljs.registerLanguage("diff",e)})();/*! `csharp` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{const n={
keyword:["abstract","as","base","break","case","catch","class","const","continue","do","else","event","explicit","extern","finally","fixed","for","foreach","goto","if","implicit","in","interface","internal","is","lock","namespace","new","operator","out","override","params","private","protected","public","readonly","record","ref","return","sealed","sizeof","stackalloc","static","struct","switch","this","throw","try","typeof","unchecked","unsafe","using","virtual","void","volatile","while"].concat(["add","alias","and","ascending","async","await","by","descending","equals","from","get","global","group","init","into","join","let","nameof","not","notnull","on","or","orderby","partial","remove","select","set","unmanaged","value|0","var","when","where","with","yield"]),
built_in:["bool","byte","char","decimal","delegate","double","dynamic","enum","float","int","long","nint","nuint","object","sbyte","short","string","ulong","uint","ushort"],
literal:["default","false","null","true"]},a=e.inherit(e.TITLE_MODE,{
begin:"[a-zA-Z](\\.?\\w)*"}),i={className:"number",variants:[{
begin:"\\b(0b[01']+)"},{
begin:"(-?)\\b([\\d']+(\\.[\\d']*)?|\\.[\\d']+)(u|U|l|L|ul|UL|f|F|b|B)"},{
begin:"(-?)(\\b0[xX][a-fA-F0-9']+|(\\b[\\d']+(\\.[\\d']*)?|\\.[\\d']+)([eE][-+]?[\\d']+)?)"
}],relevance:0},s={className:"string",begin:'@"',end:'"',contains:[{begin:'""'}]
},t=e.inherit(s,{illegal:/\n/}),r={className:"subst",begin:/\{/,end:/\}/,
keywords:n},l=e.inherit(r,{illegal:/\n/}),c={className:"string",begin:/\$"/,
end:'"',illegal:/\n/,contains:[{begin:/\{\{/},{begin:/\}\}/
},e.BACKSLASH_ESCAPE,l]},o={className:"string",begin:/\$@"/,end:'"',contains:[{
begin:/\{\{/},{begin:/\}\}/},{begin:'""'},r]},d=e.inherit(o,{illegal:/\n/,
contains:[{begin:/\{\{/},{begin:/\}\}/},{begin:'""'},l]})
;r.contains=[o,c,s,e.APOS_STRING_MODE,e.QUOTE_STRING_MODE,i,e.C_BLOCK_COMMENT_MODE],
l.contains=[d,c,t,e.APOS_STRING_MODE,e.QUOTE_STRING_MODE,i,e.inherit(e.C_BLOCK_COMMENT_MODE,{
illegal:/\n/})];const g={variants:[o,c,s,e.APOS_STRING_MODE,e.QUOTE_STRING_MODE]
},E={begin:"<",end:">",contains:[{beginKeywords:"in out"},a]
},_=e.IDENT_RE+"(<"+e.IDENT_RE+"(\\s*,\\s*"+e.IDENT_RE+")*>)?(\\[\\])?",b={
begin:"@"+e.IDENT_RE,relevance:0};return{name:"C#",aliases:["cs","c#"],
keywords:n,illegal:/::/,contains:[e.COMMENT("///","$",{returnBegin:!0,
contains:[{className:"doctag",variants:[{begin:"///",relevance:0},{
begin:"\x3c!--|--\x3e"},{begin:"</?",end:">"}]}]
}),e.C_LINE_COMMENT_MODE,e.C_BLOCK_COMMENT_MODE,{className:"meta",begin:"#",
end:"$",keywords:{
keyword:"if else elif endif define undef warning error line region endregion pragma checksum"
}},g,i,{beginKeywords:"class interface",relevance:0,end:/[{;=]/,
illegal:/[^\s:,]/,contains:[{beginKeywords:"where class"
},a,E,e.C_LINE_COMMENT_MODE,e.C_BLOCK_COMMENT_MODE]},{beginKeywords:"namespace",
relevance:0,end:/[{;=]/,illegal:/[^\s:]/,
contains:[a,e.C_LINE_COMMENT_MODE,e.C_BLOCK_COMMENT_MODE]},{
beginKeywords:"record",relevance:0,end:/[{;=]/,illegal:/[^\s:]/,
contains:[a,E,e.C_LINE_COMMENT_MODE,e.C_BLOCK_COMMENT_MODE]},{className:"meta",
begin:"^\\s*\\[(?=[\\w])",excludeBegin:!0,end:"\\]",excludeEnd:!0,contains:[{
className:"string",begin:/"/,end:/"/}]},{
beginKeywords:"new return throw await else",relevance:0},{className:"function",
begin:"("+_+"\\s+)+"+e.IDENT_RE+"\\s*(<[^=]+>\\s*)?\\(",returnBegin:!0,
end:/\s*[{;=]/,excludeEnd:!0,keywords:n,contains:[{
beginKeywords:"public private protected static internal protected abstract async extern override unsafe virtual new sealed partial",
relevance:0},{begin:e.IDENT_RE+"\\s*(<[^=]+>\\s*)?\\(",returnBegin:!0,
contains:[e.TITLE_MODE,E],relevance:0},{match:/\(\)/},{className:"params",
begin:/\(/,end:/\)/,excludeBegin:!0,excludeEnd:!0,keywords:n,relevance:0,
contains:[g,i,e.C_BLOCK_COMMENT_MODE]
},e.C_LINE_COMMENT_MODE,e.C_BLOCK_COMMENT_MODE]},b]}}})()
;hljs.registerLanguage("csharp",e)})();/*! `r` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{
const a=e.regex,n=/(?:(?:[a-zA-Z]|\.[._a-zA-Z])[._a-zA-Z0-9]*)|\.(?!\d)/,i=a.either(/0[xX][0-9a-fA-F]+\.[0-9a-fA-F]*[pP][+-]?\d+i?/,/0[xX][0-9a-fA-F]+(?:[pP][+-]?\d+)?[Li]?/,/(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?[Li]?/),s=/[=!<>:]=|\|\||&&|:::?|<-|<<-|->>|->|\|>|[-+*\/?!$&|:<=>@^~]|\*\*/,t=a.either(/[()]/,/[{}]/,/\[\[/,/[[\]]/,/\\/,/,/)
;return{name:"R",keywords:{$pattern:n,
keyword:"function if in break next repeat else for while",
literal:"NULL NA TRUE FALSE Inf NaN NA_integer_|10 NA_real_|10 NA_character_|10 NA_complex_|10",
built_in:"LETTERS letters month.abb month.name pi T F abs acos acosh all any anyNA Arg as.call as.character as.complex as.double as.environment as.integer as.logical as.null.default as.numeric as.raw asin asinh atan atanh attr attributes baseenv browser c call ceiling class Conj cos cosh cospi cummax cummin cumprod cumsum digamma dim dimnames emptyenv exp expression floor forceAndCall gamma gc.time globalenv Im interactive invisible is.array is.atomic is.call is.character is.complex is.double is.environment is.expression is.finite is.function is.infinite is.integer is.language is.list is.logical is.matrix is.na is.name is.nan is.null is.numeric is.object is.pairlist is.raw is.recursive is.single is.symbol lazyLoadDBfetch length lgamma list log max min missing Mod names nargs nzchar oldClass on.exit pos.to.env proc.time prod quote range Re rep retracemem return round seq_along seq_len seq.int sign signif sin sinh sinpi sqrt standardGeneric substitute sum switch tan tanh tanpi tracemem trigamma trunc unclass untracemem UseMethod xtfrm"
},contains:[e.COMMENT(/#'/,/$/,{contains:[{scope:"doctag",match:/@examples/,
starts:{end:a.lookahead(a.either(/\n^#'\s*(?=@[a-zA-Z]+)/,/\n^(?!#')/)),
endsParent:!0}},{scope:"doctag",begin:"@param",end:/$/,contains:[{
scope:"variable",variants:[{match:n},{match:/`(?:\\.|[^`\\])+`/}],endsParent:!0
}]},{scope:"doctag",match:/@[a-zA-Z]+/},{scope:"keyword",match:/\\[a-zA-Z]+/}]
}),e.HASH_COMMENT_MODE,{scope:"string",contains:[e.BACKSLASH_ESCAPE],
variants:[e.END_SAME_AS_BEGIN({begin:/[rR]"(-*)\(/,end:/\)(-*)"/
}),e.END_SAME_AS_BEGIN({begin:/[rR]"(-*)\{/,end:/\}(-*)"/
}),e.END_SAME_AS_BEGIN({begin:/[rR]"(-*)\[/,end:/\](-*)"/
}),e.END_SAME_AS_BEGIN({begin:/[rR]'(-*)\(/,end:/\)(-*)'/
}),e.END_SAME_AS_BEGIN({begin:/[rR]'(-*)\{/,end:/\}(-*)'/
}),e.END_SAME_AS_BEGIN({begin:/[rR]'(-*)\[/,end:/\](-*)'/}),{begin:'"',end:'"',
relevance:0},{begin:"'",end:"'",relevance:0}]},{relevance:0,variants:[{scope:{
1:"operator",2:"number"},match:[s,i]},{scope:{1:"operator",2:"number"},
match:[/%[^%]*%/,i]},{scope:{1:"punctuation",2:"number"},match:[t,i]},{scope:{
2:"number"},match:[/[^a-zA-Z0-9._]|^/,i]}]},{scope:{3:"operator"},
match:[n,/\s+/,/<-/,/\s+/]},{scope:"operator",relevance:0,variants:[{match:s},{
match:/%[^%]*%/}]},{scope:"punctuation",relevance:0,match:t},{begin:"`",end:"`",
contains:[{begin:/\\./}]}]}}})();hljs.registerLanguage("r",e)})();/*! `inform7` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>({name:"Inform 7",aliases:["i7"],
case_insensitive:!0,keywords:{
keyword:"thing room person man woman animal container supporter backdrop door scenery open closed locked inside gender is are say understand kind of rule"
},contains:[{className:"string",begin:'"',end:'"',relevance:0,contains:[{
className:"subst",begin:"\\[",end:"\\]"}]},{className:"section",
begin:/^(Volume|Book|Part|Chapter|Section|Table)\b/,end:"$"},{
begin:/^(Check|Carry out|Report|Instead of|To|Rule|When|Before|After)\b/,
end:":",contains:[{begin:"\\(This",end:"\\)"}]},{className:"comment",
begin:"\\[",end:"\\]",contains:["self"]}]})})()
;hljs.registerLanguage("inform7",e)})();/*! `lisp` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{
const n="[a-zA-Z_\\-+\\*\\/<=>&#][a-zA-Z0-9_\\-+*\\/<=>&#!]*",a="\\|[^]*?\\|",i="(-|\\+)?\\d+(\\.\\d+|\\/\\d+)?((d|e|f|l|s|D|E|F|L|S)(\\+|-)?\\d+)?",s={
className:"literal",begin:"\\b(t{1}|nil)\\b"},l={className:"number",variants:[{
begin:i,relevance:0},{begin:"#(b|B)[0-1]+(/[0-1]+)?"},{
begin:"#(o|O)[0-7]+(/[0-7]+)?"},{begin:"#(x|X)[0-9a-fA-F]+(/[0-9a-fA-F]+)?"},{
begin:"#(c|C)\\("+i+" +"+i,end:"\\)"}]},b=e.inherit(e.QUOTE_STRING_MODE,{
illegal:null}),g=e.COMMENT(";","$",{relevance:0}),r={begin:"\\*",end:"\\*"},t={
className:"symbol",begin:"[:&]"+n},c={begin:n,relevance:0},d={begin:a},o={
contains:[l,b,r,t,{begin:"\\(",end:"\\)",contains:["self",s,b,l,c]},c],
variants:[{begin:"['`]\\(",end:"\\)"},{begin:"\\(quote ",end:"\\)",keywords:{
name:"quote"}},{begin:"'"+a}]},v={variants:[{begin:"'"+n},{
begin:"#'"+n+"(::"+n+")*"}]},m={begin:"\\(\\s*",end:"\\)"},u={endsWithParent:!0,
relevance:0};return m.contains=[{className:"name",variants:[{begin:n,relevance:0
},{begin:a}]},u],u.contains=[o,v,m,s,l,b,g,r,t,d,c],{name:"Lisp",illegal:/\S/,
contains:[l,e.SHEBANG(),s,b,g,o,v,m,c]}}})();hljs.registerLanguage("lisp",e)
})();/*! `haxe` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>({name:"Haxe",aliases:["hx"],keywords:{
keyword:"break case cast catch continue default do dynamic else enum extern for function here if import in inline never new override package private get set public return static super switch this throw trace try typedef untyped using var while Int Float String Bool Dynamic Void Array ",
built_in:"trace this",literal:"true false null _"},contains:[{
className:"string",begin:"'",end:"'",contains:[e.BACKSLASH_ESCAPE,{
className:"subst",begin:"\\$\\{",end:"\\}"},{className:"subst",begin:"\\$",
end:/\W\}/}]
},e.QUOTE_STRING_MODE,e.C_LINE_COMMENT_MODE,e.C_BLOCK_COMMENT_MODE,e.C_NUMBER_MODE,{
className:"meta",begin:"@:",end:"$"},{className:"meta",begin:"#",end:"$",
keywords:{keyword:"if else elseif end error"}},{className:"type",
begin:":[ \t]*",end:"[^A-Za-z0-9_ \t\\->]",excludeBegin:!0,excludeEnd:!0,
relevance:0},{className:"type",begin:":[ \t]*",end:"\\W",excludeBegin:!0,
excludeEnd:!0},{className:"type",begin:"new *",end:"\\W",excludeBegin:!0,
excludeEnd:!0},{className:"class",beginKeywords:"enum",end:"\\{",
contains:[e.TITLE_MODE]},{className:"class",beginKeywords:"abstract",
end:"[\\{$]",contains:[{className:"type",begin:"\\(",end:"\\)",excludeBegin:!0,
excludeEnd:!0},{className:"type",begin:"from +",end:"\\W",excludeBegin:!0,
excludeEnd:!0},{className:"type",begin:"to +",end:"\\W",excludeBegin:!0,
excludeEnd:!0},e.TITLE_MODE],keywords:{keyword:"abstract from to"}},{
className:"class",begin:"\\b(class|interface) +",end:"[\\{$]",excludeEnd:!0,
keywords:"class interface",contains:[{className:"keyword",
begin:"\\b(extends|implements) +",keywords:"extends implements",contains:[{
className:"type",begin:e.IDENT_RE,relevance:0}]},e.TITLE_MODE]},{
className:"function",beginKeywords:"function",end:"\\(",excludeEnd:!0,
illegal:"\\S",contains:[e.TITLE_MODE]}],illegal:/<\//})})()
;hljs.registerLanguage("haxe",e)})();/*! `graphql` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>{const a=e.regex;return{name:"GraphQL",
aliases:["gql"],case_insensitive:!0,disableAutodetect:!1,keywords:{
keyword:["query","mutation","subscription","type","input","schema","directive","interface","union","scalar","fragment","enum","on"],
literal:["true","false","null"]},
contains:[e.HASH_COMMENT_MODE,e.QUOTE_STRING_MODE,e.NUMBER_MODE,{
scope:"punctuation",match:/[.]{3}/,relevance:0},{scope:"punctuation",
begin:/[\!\(\)\:\=\[\]\{\|\}]{1}/,relevance:0},{scope:"variable",begin:/\$/,
end:/\W/,excludeEnd:!0,relevance:0},{scope:"meta",match:/@\w+/,excludeEnd:!0},{
scope:"symbol",begin:a.concat(/[_A-Za-z][_0-9A-Za-z]*/,a.lookahead(/\s*:/)),
relevance:0}],illegal:[/[;<']/,/BEGIN/]}}})();hljs.registerLanguage("graphql",e)
})();/*! `ocaml` grammar compiled for Highlight.js 11.5.1 */
(()=>{var e=(()=>{"use strict";return e=>({name:"OCaml",aliases:["ml"],
keywords:{$pattern:"[a-z_]\\w*!?",
keyword:"and as assert asr begin class constraint do done downto else end exception external for fun function functor if in include inherit! inherit initializer land lazy let lor lsl lsr lxor match method!|10 method mod module mutable new object of open! open or private rec sig struct then to try type val! val virtual when while with parser value",
built_in:"array bool bytes char exn|5 float int int32 int64 list lazy_t|5 nativeint|5 string unit in_channel out_channel ref",
literal:"true false"},illegal:/\/\/|>>/,contains:[{className:"literal",
begin:"\\[(\\|\\|)?\\]|\\(\\)",relevance:0},e.COMMENT("\\(\\*","\\*\\)",{
contains:["self"]}),{className:"symbol",begin:"'[A-Za-z_](?!')[\\w']*"},{
className:"type",begin:"`[A-Z][\\w']*"},{className:"type",
begin:"\\b[A-Z][\\w']*",relevance:0},{begin:"[a-z_]\\w*'[\\w']*",relevance:0
},e.inherit(e.APOS_STRING_MODE,{className:"string",relevance:0
}),e.inherit(e.QUOTE_STRING_MODE,{illegal:null}),{className:"number",
begin:"\\b(0[xX][a-fA-F0-9_]+[Lln]?|0[oO][0-7_]+[Lln]?|0[bB][01_]+[Lln]?|[0-9][0-9_]*([Lln]|(\\.[0-9_]*)?([eE][-+]?[0-9_]+)?)?)",
relevance:0},{begin:/->/}]})})();hljs.registerLanguage("ocaml",e)})();