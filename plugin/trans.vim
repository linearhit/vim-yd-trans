"the trans function by TL
function! <SID>TransL(word)
python3 << EOF

# coding=utf-8

import vim, urllib.request, sys
def tras(word):

    s = "trans-container"
    err = "error-wrapper"

    request = "http://dict.youdao.com/search?q=" \
            + word + "&keyfrom=dict.index"

    try:
        url = urllib.request.urlopen(request, None, 2)
        d = url.read()
        epos = d.find(err.encode("utf-8"))

        if epos != -1:
            print("can't find ")
            return
        else:
            print(word + ":")

        encoded_s = s.encode("utf-8")
        pos = d.find(encoded_s)
        ret = d[pos : pos + 1000]

        pos = ret.find("<ul>".encode())
        pos1 = ret.find("</ul>".encode(), pos)
        if pos1 < pos:
            print('not find.')
            return
        ret = ret[pos + 4 : pos1]
        if "<span".encode() in ret:
            idn = "class=\"pos\">"
            pos = ret.find(idn.encode())
            pos = pos + len(idn)
            pos1 = ret.find("</span".encode(), pos)
            print("    " + ret[pos : pos1])
            idn2 = "class=\"def\">"
            pos = ret.find(idn2.encode(), pos1)
            pos = pos + len(idn2)
            pos1 = ret.find("</span".encode(), pos)
            print(("    " + ret[pos : pos1]).decode())
        else:
            ret = ret.replace('<li>'.encode(), ''.encode())
            ret = ret.replace('</li>'.encode(), ''.encode())
            print(ret.decode())

    except URLError as e:
        print(e.reason)

    return

word=vim.eval("a:word")
tras(word)
EOF
endfunction

function! <SID>GetWD() 
   let s:word = expand('<cword>')
   call <SID>TransL(s:word)
endfunction

function! <SID>GetVWD()
    let s:word = <SID>GetVisualSelection()
    call <SID>TransL(s:word)
endfunction


function! <SID>GetVisualSelection()
    try
        let a_save = @a
        normal! gv"ay
        return @a
    finally
        let @a = a_save
    endtry
endfunction

command GetWD :call <SID>GetWD()
command GetVWD :call <SID>GetVWD()
"nmap <silent> <c-s-K> <Esc>: call GetWD() <CR>
"vmap <silent> <c-s-K> <Esc>: call GetVWD()<CR>
