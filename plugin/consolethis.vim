" Console log the current item under cursor

" Make sure Python is ready
if !has("python")
  echo "vim has to be compiled with +python to run this"
  finish
endif

python << endblock

import vim

def findIndent(line):
    indent = len(line) - len(line.lstrip(' '))
    return indent

def getIndentStr(indent):
    line = ''
    custom = 2
    if indent ==  0:
        custom = 0
    # custom can be added to indent in range function
    for x in range(indent):
        line += ' '
    return line

def getWordUnderCursor():
  return vim.eval("expand('<cWORD>')")


def cleanCurrWord(curr):
    spcl_list = ['{', '(', ')', ',', '}', ':']
    try:
        for ch in spcl_list:
            if ch in curr:
                curr = curr.replace(ch, " ")
        item = curr.split(' ')[-2]
        return item
    except:
        return curr


def getFileExtension():
    curr_file = vim.current.buffer.name
    ext = curr_file.split(".")[-1]
    return ext


def getSpecificConsole(ext, word):
    if ext == 'js':
        return ("console.log(%s)" % (word))
    elif ext == 'py':
        return ("print(%s)" % (word))
    elif ext == 'go':
        return ('fmt.Sprintf("%%v", %s)' %(word) )
    else:
        return ''


def consoleThis():
  curr = getWordUnderCursor()
  clean_word = cleanCurrWord(curr)

  indent = findIndent(vim.current.line)
  indentLine = getIndentStr(indent)

  ext = getFileExtension()
  console = getSpecificConsole(ext, clean_word)
  finalLine = "" + indentLine + console

  x = vim.current.range
  x.append(finalLine)

endblock

nmap <silent> ,, :python consoleThis()<CR>
