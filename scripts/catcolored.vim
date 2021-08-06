function! s:color_to_ansi(cstr, is_bg)
	let l:car=a:is_bg ? 40 : 30
	let l:cdr=[]
	if a:cstr[0] == '#'
		let l:car+=8
		let l:cdr=[2] + map(split(a:cstr[1:], '\v..\zs'), 'str2nr(v:val, 16)')
	elseif a:cstr > 15
		let l:car+=8
		let l:cdr=[5, a:cstr]
	else
		let l:cstr = a:cstr
		if l:cstr > 7
			let l:cstr-=8
			let l:car+=60
		endif
		let l:car+=l:cstr
	endif
	return [printf("\x1b[%sm", join([l:car] + l:cdr, ';')), "\x1b[m"]
endfunction

function! s:is_number(s)
	return str2nr(a:s) . '' == a:s
endfunction

function! s:synID_to_ansi(synID)
	let l:bga=''
	let l:fga=''
	let l:a=''
	let l:bgs=synIDattr(a:synID, 'bg')
	if !s:is_number(l:bgs)
		let l:bgs=synIDattr(a:synID, 'bg#')
	endif
	let l:fgs=synIDattr(a:synID, 'fg')
	if !s:is_number(l:fgs)
		let l:fgs=synIDattr(a:synID, 'fg#')
	endif
	if strchars(l:bgs)
		let l:bga=s:color_to_ansi(l:bgs, 1)[0]
	endif
	if strchars(l:fgs)
		let l:fga=s:color_to_ansi(l:fgs, 0)[0]
	endif
	return [l:bga . l:fga . l:a,  "\x1b[m"]
endfunction

function! s:buffer_to_ansi()
	let l:lncnt=line('$')
	let l:synreg={}
	let l:alines=[]
	let l:back={}
	for l:i in range(1, l:lncnt)
		let l:ln=getline(l:i)
		let l:lnchars=split(l:ln, '\zs')
		let l:lastsi=-1
		let l:styleend=''
		let l:aln=''
		for l:j in range(1, strlen(l:ln))
			let l:si=synIDtrans(synID(l:i, l:j, 1))
			if l:si != l:lastsi
				let l:style=[]
				if !has_key(l:synreg, l:si)
					let l:style=s:synID_to_ansi(l:si)
					let l:synreg[l:si]=l:style
				else
					let l:style=l:synreg[l:si]
				endif
				let l:aln.=l:styleend . l:style[0] . l:ln[l:j - 1]
				let l:styleend=l:style[1]
				let l:lastsi=l:si
			else
				let l:aln.=l:ln[l:j - 1]
			endif
		endfor
		let l:aln.=l:styleend
		call insert(l:alines, l:aln)
	endfor
	call reverse(l:alines)
	return l:alines
endfunction

call writefile(s:buffer_to_ansi(), '/dev/stdout', 'a')
