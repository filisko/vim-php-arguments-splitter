if exists('g:PhpArgumentsSplitterLoaded') || &cp
  finish
end
let g:PhpArgumentsSplitterLoaded = 1

function s:ArgumentsCanBeSplit()
  let lineNumber = line('.')
  let lineContent = getline(lineNumber)

  if lineContent !~ "function" || lineContent !~ ")"
    return 0
  endif

  return 1
endfunction

function s:ArgumentsCanBeUnsplit()
  let lineNumber = line('.')
  let lineContent = getline(lineNumber)
  
  if lineContent !~ "function" || lineContent =~ ")"
    return 0
  endif

  return 1
endfunction

function PhpArgumentsSplit()
  let lineNumber = line('.')
  let lineContent = getline(lineNumber)

  if s:ArgumentsCanBeSplit() == 0
    return 'Not a function'
  endif

  let numberOfSpacesConsideredOneTab = &shiftwidth
  let baseIndentLevel = matchstr(lineContent, ' *')
  let oneIndentLevel = repeat(' ', numberOfSpacesConsideredOneTab)
  " let currentIndentLevel = strlen(baseIndentLevel) / numberOfSpacesConsideredOneTab
  
  let refactoredLineContent = lineContent

  " remove function's opening bracket (will be added later)
  if lineContent =~ "{"
    " remove from same line
    let refactoredLineContent = substitute(refactoredLineContent, ' *{', '', 'g')
  else
    " remove from next line
    execute (lineNumber+1) . 'd'

    " move back to function line
    execute lineNumber
  endif
  

  " move everything after open parenthesis to next line and indent it (base leve +1)
  let correctFirstParam = printf("\(\n%s%s", baseIndentLevel, oneIndentLevel)
  let refactoredLineContent = substitute(refactoredLineContent, "\( *", correctFirstParam, "g")

  " enter newline after every comma and indent them (base level + 1)
  let correctMiddleParams = printf("\,\n%s%s", baseIndentLevel, oneIndentLevel)
  let refactoredLineContent = substitute(refactoredLineContent, " *\, *", correctMiddleParams, "g")

  " move closing parenthesis to its own line and indent it (base level) 
  let correctLastParam = printf("\n%s\)", baseIndentLevel)
  let refactoredLineContent = substitute(refactoredLineContent, " *\)", correctLastParam, "g")

  " remove extra spaces before return type
  let refactoredLineContent = substitute(refactoredLineContent, "\)\: *", "\)\: ", "g")

  " insert open bracket after closing parenthesis and enter new line: ) {
  let refactoredLineContent = refactoredLineContent . " \{\n"


  let o = @o
  let @o = refactoredLineContent
  normal! V"op
  let @o=o
endfunction


function PhpArgumentsUnsplit()
  let lineNumber = line('.')
  let lineContent = getline(lineNumber)

  if s:ArgumentsCanBeUnsplit() == 0
    " echom 'Not a function'
    return 'Not a function'
  endif

  let numberOfSpacesConsideredOneTab = &shiftwidth
  let baseIndentLevel = matchstr(lineContent, ' *')
  let oneIndentLevel = repeat(' ', numberOfSpacesConsideredOneTab)
  " echom strlen(baseIndentLevel)

  let functionContent = ""
  let numberOfLinesToClosingParenthesis = 0
  let closingParenthesisFound = 0

  while numberOfLinesToClosingParenthesis <= 30
    let nextLineContent = getline(lineNumber+numberOfLinesToClosingParenthesis)
    let functionContent = functionContent.nextLineContent

    let numberOfLinesToClosingParenthesis += 1

    if nextLineContent =~ ")" && nextLineContent =~ "{"
      let closingParenthesisFound = 1
      break
    endif
  endwhile

  if closingParenthesisFound == 0
    echom 'Closing parenthesis of function not found'
    return
  endif

  " remove lines
  execute 'j' . numberOfLinesToClosingParenthesis

  let refactoredContent = functionContent

  " remove spaces after opening parenthesis
  let refactoredContent = substitute(refactoredContent, "\( *", "\(", "g")

  " remove extra spaces after and before commas
  let refactoredContent = substitute(refactoredContent, " *\, *", "\, ", "g")
  
  " remove extra spaces before closing parenthesis
  let refactoredContent = substitute(refactoredContent, " *\)", "\)", "g")
  
  " remove extra spaces before opening brackets
  let refactoredContent = substitute(refactoredContent, " *\{", " \{", "g")
  
  " remove extra spaces before return type
  let refactoredContent = substitute(refactoredContent, "\)\: *", "\)\: ", "g")

  if refactoredContent =~ join(['.*protected.*function.*(', '.*public.*function.*(', '.*private.*function.*('], '\|')
    " add new line after closing parenthesis if we're in class
    let refactoredContent = substitute(refactoredContent, "\) *\{", "\)\n".baseIndentLevel."\{", "g")
  endif

  let o = @o
  let @o = refactoredContent
  normal! V"op
  let @o=o
endfunction


function PhpToggle()
  if s:ArgumentsCanBeSplit() == 1
    call PhpArgumentsSplit()
    return 1
  endif
  
  if s:ArgumentsCanBeUnsplit() == 1
    call PhpArgumentsUnsplit()
    return 1
  endif

  return 0
endfunction

command Ptoggle :call PhpToggle()