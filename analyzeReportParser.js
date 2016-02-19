fs = require('fs')

if (process.argv.length < 3) {
  console.log('No such file');
  process.exit(1)
}
const jsonFile = process.argv[2]
var commit
if (process.argv.length > 3) {
  commit = process.argv[3]
}
fs.readFile(jsonFile, 'utf8', (err, result) => {
  if (err) {
    return console.log(err)
  }
  result = JSON.parse(result)
  const issues = result['diagnostics']
  
  const println = console.log
  println('<!Doctype html>')
  println('<html xmlns=http://www.w3.org/1999/xhtml>')
  println('<head><meta http-equiv=Content-Type content="text/html;charset=utf-8"></head>')
  println('<body>')
  println('<style>')
  println('.Error{color: red}')
  println('.Warning{color: #ec8e1d}')
  println('.Concern{color: #ceca41}')
  println('.file{padding-top:10px; font-size: 16}')
  println('code{font-family: monospace}')
  println('.info{margin-top:10px;padding:10px; font-size: 12; background: #f0f0f0; width: 640px;}')
  println('.desc{padding:10px; font-size: 12; background: #f0f0f0; width: 640px;}')
  println('.sep{padding-top: 10px; font-size: 20;}')
  println('.hidden{display: none;}')
  println('.showDetail{text-decoration: none; font-size: 14px; color: #999;}')
  println('</style>')
  issues.sort((a, b) => (b.severity - a.severity) || (b.confidence - a.confidence) || (b.ruleName !== a.ruleName ? 1 : 0))

  const rules = []
  const ruleMap = {}
  issues.forEach((issue, i) => {
    const level = issue.severityDescription
    const title = issue.ruleName
    const desc = issue.html.ruleDescription
    const info = issue.html.info
    var path = issue.file
    var file = path ? path.split('/').slice(-1)[0] : null
    const method = issue.context
    const snippet = issue.fileSnippet
    var line = issue.extent.start.line
    const endLine = issue.extent.end.line
    if (line !== endLine) {
      line = line + '-' + endLine
    }
    if (line && file) {
      file += ':' + line
    }
    if (commit && path) {
      if (path.indexOf('/Pods/') > 0) {
        path = path.split('/Pods/').slice(-1)[0]
        const proj = path.split('/')[0]
        path = path.split(proj).slice(-1)[0]
        path = 'http://git.husor.com.cn/Pods/' + proj + '/blob/master' + path
      } else {
        path = path.split('/beibei/').slice(-1)[0]
        path = 'http://git.husor.com.cn/ios/beibei/blob/' + commit + '/' + path
      }
    }
    const simpleIssue = {
      level: level,
      title: title,
      desc: desc,
      info: info,
      path: path,
      file: file,
      method: method,
      snippet: snippet,
    }
    var ruleExisted = false
    for (var i = 0; i < rules.length; i++) {
      if (rules[i] === title) {
        ruleExisted = true
        break
      }
    }
    if (!ruleExisted) {
      rules.push(title)
      ruleMap[title] = [simpleIssue]
    } else {
      ruleMap[title].push(simpleIssue)
    }
  })
  rules.forEach((rule) => {
    const issues = ruleMap[rule]
    if (issues.length > 100) {
      return
    }
    issues.forEach((issue, i) => {
      if (i === 0) {
        println('<h3 class="' + issue.level + '">' + issue.level + ': ' + issue.title + '（' + issues.length + '个）</h3>')
      }
      println('<div class="issue">')
      const showDetailTag = (i === 0) ? '' : '&nbsp;&nbsp;<a class="showDetail" href="javascript:;" onClick="showDetail(this)">显示详情</a>'
      function printTitle() {
        if (issue.file) {
          if (issue.path) {
            if (issue.file) println('<div class="file"><a href="' + issue.path + '">' + issue.file + '</a>' + showDetailTag + '</div>')
          } else {
            if (issue.file) println('<div class="file">' + issue.file + showDetailTag + '</div>')
          }
        }
      }
      if (i === 0 || (!issue.file && !issue.snippet)) {
        printTitle()
        if (issue.snippet) println('<div class="snippet"><code>' + issue.snippet + '</code></div>')
        if (issue.info) println('<div class="info">' + issue.info + '</div>')
        if (issue.desc) println('<div class="desc">' + issue.desc + '</div>')
      } else {
        printTitle()
        if (issue.snippet) println('<div class="snippet"><code>' + issue.snippet + '</code></div>')
        if (issue.info) println('<div class="info hidden">' + issue.info + '</div>')
        if (issue.desc) println('<div class="desc hidden">' + issue.desc + '</div>')
      }
      println('</div>')
      if (i === 0) {
        println('<div class="sep">同类问题</div>')
      }
    })
  })
  println('<script>')
  println('function showDetail(link) {')
  println('if (link.innerHTML === "显示详情") {')
  println('var infos = link.parentElement.parentElement.getElementsByClassName("hidden");')
  println('var len = infos.length; for (var i=0; i < len; i++) {infos[0].className = infos[0].className.replace(/hidden/,"show")}')
  println('link.innerHTML = "隐藏详情"')
  println('} else {')
  println('var infos = link.parentElement.parentElement.getElementsByClassName("show");')
  println('var len = infos.length; for (var i=0; i < len; i++) {infos[0].className = infos[0].className.replace(/show/,"hidden")}')
  println('link.innerHTML = "显示详情"')
  println('}}')
  println('</script>')
  println('</body>')
})