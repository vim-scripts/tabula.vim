" ============================================================================
" Filename:	 tabula.vim
" Last Modified: 2010-03-16
" Version:       1.4
" Maintainer:	 Bernd Pol (bernd.pol AT online DOT de)
" Copyright:	 2006-2009 Bernd Pol
"                This script is free software; you can redistribute it and/or 
"                modify it under the terms of the GNU General Public License as 
"                published by the Free Software Foundation; either version 2 of 
"                the License, or (at your option) any later version. 
" Description:   Vim colorscheme based on marklar.vim by SM Smithfield,
" 		 slightly modified for harmonic, yet easily distinguishable
" 		 display on GUI and a 256 color xterm as well.
" Install:       Put this file in the users colors directory (~/.vim/colors)
"                then load it with :colorscheme tabula
" =============================================================================
" CHANGES
" - Multiple constant colors reworked
" FIXME
" - Tabula dialog does not reset constant colors to one color only when they
"   had been previously changed to multiple colors. Needs ":color tabula" then.
"   (Could there be some overflow on multiple Tabula() calls?)
"   Ditto on some other local changes, e.g. underline TODO.
"   Appears to have no effect if tabula changed while being in another window.
"   Console terminal:
"   When character display set to not colored, colors remain, other atts change.
" TODO
" - add an options settings menu to gvim
" - keep options in some setup file, e.g.:
"   tabula.rc, sub e.g. "<OPTIONS> ... </OPTIONS>" marks
" - options set up per directory (autoload option)
"   such that text files be displayed other than e.g. c sources
" =============================================================================

" Preliminaries
" 
hi clear
set background=dark

if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "tabula"

"==============================================================================
"			       Option Settings				   {{{1
"==============================================================================
"
" Use these in your .vimrc file before the ':colorscheme tabula' line
"
" Alternatively set the options variable from the command line, e.g.
" 	:let Tabula_LNumUnderline=1
" and then call
" 	:colorscheme tabula
" again.

"------------------------------------------------------------------------------
" Display Statements In Bold:						   {{{2
" 	Tabula_BoldStatement = 0	statements display not bold
" 	Tabula_BoldStatement = 1	statements display bold
" Defaults to non-bold display.
"------------------------------------------------------------------------------
"
let s:BoldStatement = 0
if exists("g:Tabula_BoldStatement")
  let s:BoldStatement = g:Tabula_BoldStatement
endif

"------------------------------------------------------------------------------
" Set GUI Cursor Color:							   {{{2
"	Tabula_CurColor = 'blue'
"	Tabula_CurColor = 'red'
"	Tabula_CurColor = 'yellow'
"	Tabula_CurColor = 'white'
" Defaults to 'blue'.
"------------------------------------------------------------------------------
"
let s:CurColor = "blue"
if exists("g:Tabula_CurColor")
  let s:CurColor = g:Tabula_CurColor
endif

"------------------------------------------------------------------------------
" Set Color For Preprocessor Statements:				   {{{2
"	Tabula_ColorPre = 'blue'	purple-blue
"	Tabula_ColorPre = 'red'		orange-red
"	Tabula_ColorPre = 'yellow'	lightgreen-yellow
" Defaults to 'blue'.
"------------------------------------------------------------------------------
"
let s:ColorPre = "blue"
if exists("g:Tabula_ColorPre")
  if g:Tabula_ColorPre == "red" || g:Tabula_ColorPre == "yellow"
    let s:ColorPre = g:Tabula_ColorPre
  endif
endif

"------------------------------------------------------------------------------
" Use Dark Error Background:						   {{{2
" Sometimes desirable for less distracting error highlighting.
" 	Tabula_DarkError = 0		light red error background
" 	Tabula_DarkError = 1		dark red error background
" Defaults to light error background.
"------------------------------------------------------------------------------
"
let s:DarkError = 0
if exists("g:Tabula_DarkError")
  let s:DarkError = g:Tabula_DarkError
endif

"------------------------------------------------------------------------------
" Use Multiple Colors For Constant Values:				   {{{2
" 	Tabula_FlatConstants = 0	use different color for each type
" 	Tabula_FlatConstants = 1	use common color for all
" Defaults to using common colors.
"------------------------------------------------------------------------------
"
let s:FlatConstants = 1
if exists("g:Tabula_FlatConstants")
  let s:FlatConstants = g:Tabula_FlatConstants
endif

"------------------------------------------------------------------------------
" How To Display Ignore And NonText Characters:				   {{{2
" 	Tabula_InvisibleIgnore = 0	slightly visible
" 					(good for Vim documentation editing)
"	Tabula_InvisibleIgnore = 1	invisible on standard background
" Defaults to invisible display.
"------------------------------------------------------------------------------
"
let s:InvisibleIgnore = 1
if exists("g:Tabula_InvisibleIgnore")
  let s:InvisibleIgnore = g:Tabula_InvisibleIgnore
endif

"------------------------------------------------------------------------------
" Show Line Numbers Underlined:						   {{{2
" Sometimes useful to spot a line more easily.
" 	Tabula_LNumUnderline = 0	not underlined
"	Tabula_LNumUnderline = 1	line numbers are underlined
" Defaults to not underlined.
"------------------------------------------------------------------------------
"
let s:LNumUnderline = 0
if exists("g:Tabula_LNumUnderline")
  let s:LNumUnderline = g:Tabula_LNumUnderline
endif

"------------------------------------------------------------------------------
" Let Search Occurrences Stand Out More Prominently:			   {{{2
"	Tabula_SearchStandOut = 0	normal dark background display
"	Tabula_SearchStandOut = 1	prominent underlined display
"	Tabula_SearchStandOut = 2	even more prominent display
" Defaults to normal display.
"------------------------------------------------------------------------------
"
let s:SearchStandOut=0
if exists("g:Tabula_SearchStandOut")
  let s:SearchStandOut = g:Tabula_SearchStandOut
endif

"------------------------------------------------------------------------------
" How To Display TODOs And Similar:					   {{{2
"	Tabula_TodoUnderline = 0	display on a blue background
"	Tabula_TodoUnderline = 1	display them underlined white
" Defaults to underlined display.
"------------------------------------------------------------------------------
"
let s:TodoUnderline=1
if exists("g:Tabula_TodoUnderline")
  let s:TodoUnderline = g:Tabula_TodoUnderline
endif

"------------------------------------------------------------------------------
" How To Display Typographic Character Values:				   {{{2
"	Tabula_CharValuesColored = 0	colored in addition to typographics
"	Tabula_CharValuesColored = 1	not colored, term. italics enhanced
"	Tabula_CharValuesColored = 2	not colored, term. underlined enhanced
" Defaults to a colored typographics character values display.
"
" NOTE: Colored is to be preferred in terminal-based vim because there is no
"       easy way to distinguish italic from underline. Currently there are two
"       modes: enhance (reversed display) italics and enhance underline two
"       ease this situation a bit. This sub-modes do not affect the GUI display
"       however.
"------------------------------------------------------------------------------
"
let s:CharValuesColored=0
if exists("g:Tabula_CharValuesColored")
  let s:CharValuesColored = g:Tabula_CharValuesColored
endif

"==============================================================================
"			      Initial Tabula Call			   {{{1
"==============================================================================

" NOTE: Still does not work. It appears that the buffer colors will not be
" re-evaluated upin a simple parameter change.
" "colorscheme tabula" still needs to be issued after a parameter change through
" a Tabula() call.

"call TabulaMain()

"==============================================================================
"			    The Tabula Main Function
"==============================================================================

" if !exists("TabulaMain")
"   function! TabulaMain()
" 
"   if exists("syntax_on")
"     syntax reset
"   endif
"   let g:colors_name = "tabula"

"==============================================================================
"			      Color Definitions				   {{{1
"==============================================================================
"
"==============================================================================
"				Dark Background				   {{{2
"==============================================================================
"
" This is default unless we really want light.
"
" NOTE: light background is still TODO (may never happen, though)

"=============================== Font Elements =========================== {{{3
"
hi Normal		guifg=#71D289	guibg=#004A41			ctermfg=84	ctermbg=23 
hi Underlined						gui=underline					cterm=underline

"================================ Vim Specific =========================== {{{3
"------------------------------------------------------------------------------
" Version_7 Specials:							   {{{4
"------------------------------------------------------------------------------
"
if version >= 700
    hi SpellBad        	guisp=#FF0000
    hi SpellCap        	guisp=#afaf00
    hi SpellRare       	guisp=#bf4040
    hi SpellLocal     	guisp=#00afaf							ctermbg=0
    hi Pmenu		guifg=#00ffff	guibg=#000000			ctermfg=51	ctermbg=0
    hi PmenuSel       	guifg=#ffff00	guibg=#000000	gui=bold	ctermfg=226			cterm=bold
    hi PmenuSbar       			guibg=#204d40					ctermbg=6
    hi PmenuThumb      	guifg=#38ff56					ctermfg=3
    hi CursorColumn		    	guibg=#096354					ctermbg=29
    hi CursorLine		      	guibg=#096354					ctermbg=29
    hi Tabline         	guifg=bg	guibg=fg	gui=NONE	ctermfg=NONE	ctermbg=NONE	cterm=reverse,bold
    hi TablineSel      	guifg=#20012e	guibg=#00a675	gui=bold
    hi TablineFill     	guifg=#689C7C
    hi MatchParen      	guifg=#38ff56	guibg=#0000ff	gui=bold	ctermfg=14	ctermbg=21	cterm=bold
endif

"------------------------------------------------------------------------------
" Vim Window Elements:							   {{{4
"------------------------------------------------------------------------------
"
hi Question		guifg=#E5E500	guibg=NONE	gui=NONE	ctermfg=11	ctermbg=NONE	cterm=NONE
hi StatusLine		guifg=#000000	guibg=#7DCEAD	gui=NONE			ctermbg=00	cterm=reverse
hi StatusLineNC		guifg=#245748	guibg=#689C7C	gui=NONE	ctermfg=72	ctermbg=23	cterm=reverse
hi Title		guifg=#7CFC94	guibg=NONE	gui=bold	ctermfg=2			cterm=bold
hi VertSplit		guifg=#245748	guibg=#689C7C	gui=NONE	ctermfg=72	ctermbg=23	cterm=reverse
hi Visual 				guibg=#0B7260	gui=NONE
hi WarningMsg		guifg=#000087	guibg=#FFFF00			ctermfg=18	ctermbg=11
hi WildMenu		guifg=#20012e	guibg=#00a675	gui=bold	ctermfg=NONE	ctermbg=NONE	cterm=bold

"------------------------------------------------------------------------------
" Cursor Colors:							   {{{4
"------------------------------------------------------------------------------
"
if s:CurColor == "yellow"
  hi Cursor		guifg=#000000	guibg=#EFEF00
elseif s:CurColor == "red"
  " Note: Input cursor will be invisible on Error Group
  hi Cursor		guifg=#00007F	guibg=#F70000
elseif s:CurColor == "blue"
  hi Cursor		guifg=#00007F	guibg=#00EFEF
elseif s:CurColor == "white"
  hi Cursor		guifg=#000000	guibg=#FFFFFF
endif

"------------------------------------------------------------------------------
" Diff Colors:								   {{{4
"------------------------------------------------------------------------------
"
hi DiffAdd		guifg=NONE	guibg=#136769 			ctermfg=4	ctermbg=7	cterm=NONE
hi DiffDelete		guifg=NONE	guibg=#50694A 			ctermfg=1 	ctermbg=7	cterm=NONE
hi DiffChange		guifg=fg	guibg=#00463c	gui=None	ctermfg=4 	ctermbg=2	cterm=NONE
hi DiffText		guifg=#7CFC94	guibg=#00463c	gui=bold 	ctermfg=4 	ctermbg=3	cterm=NONE
hi Directory		guifg=#25B9F8	guibg=NONE							ctermfg=2

"------------------------------------------------------------------------------
" Error Colors:								   {{{4
"------------------------------------------------------------------------------
"
if s:DarkError == 1
  hi Error		guifg=NONE	guibg=#303800	gui=NONE	ctermfg=NONE 	ctermbg=237	cterm=NONE
else
  if s:CurColor == "red"
    " Note: We need another background in this case to keep the cursor visible.
    hi Error		guifg=#FF0000	guibg=#FFFF00	gui=bold	ctermfg=11 	ctermbg=9	cterm=NONE
  else
    hi Error		guifg=#FFFF00	guibg=#FF0000	gui=NONE	ctermfg=11 	ctermbg=9	cterm=NONE
  endif
endif
hi ErrorMsg		guifg=#FFFFFF	guibg=#FF0000			ctermfg=7	ctermbg=1

"------------------------------------------------------------------------------
" Fold Colors:								   {{{4
"------------------------------------------------------------------------------

hi FoldColumn		guifg=#00BBBB	guibg=#4E4E4E			ctermfg=14 	ctermbg=240
hi Folded		guifg=#44DDDD	guibg=#4E4E4E			ctermfg=14 	ctermbg=240

"------------------------------------------------------------------------------
" Ignore Variants:							   {{{4
"------------------------------------------------------------------------------
"
if s:InvisibleIgnore == 1
  " completely invisible
  hi Ignore		guifg=bg	guibg=NONE			ctermfg=23
  hi NonText		guifg=bg	guibg=NONE			ctermfg=23
else
  " nearly invisible
  hi Ignore		guifg=#005FAF	guibg=NONE			ctermfg=26
  hi NonText		guifg=#005FAF	guibg=NONE			ctermfg=26
endif

"------------------------------------------------------------------------------
" Line Number Variants:							   {{{4
" Lines can sometimes be more precisely identified if the line numbers are
" underlined.
"------------------------------------------------------------------------------
"
if s:LNumUnderline == 1
  hi LineNr		guifg=#00FF00	guibg=#005080	gui=underline	ctermfg=84	ctermbg=24	cterm=underline
else
  hi LineNr		guifg=#00FF00	guibg=#005080			ctermfg=84	ctermbg=24
endif

"------------------------------------------------------------------------------
" Messages:								   {{{4
"------------------------------------------------------------------------------

hi ModeMsg		guifg=#FFFFFF	guibg=#0000FF	gui=NONE	ctermfg=7	ctermbg=4	cterm=NONE
hi MoreMsg		guifg=#FFFFFF	guibg=#00A261	gui=NONE	ctermfg=7	ctermbg=28	cterm=NONE

"------------------------------------------------------------------------------
" Search Stand Out Variants:						   {{{4
"------------------------------------------------------------------------------
"
if s:SearchStandOut == 0
  hi IncSearch		guifg=#D0D0D0	guibg=#206828	gui=NONE	ctermfg=NONE	ctermbg=22	cterm=NONE
  hi Search		guifg=NONE	guibg=#212a81			ctermfg=NONE	ctermbg=18
elseif s:SearchStandOut == 1
  hi IncSearch		guifg=#D0D0D0	guibg=#206828	gui=underline	ctermfg=252	ctermbg=22	cterm=underline
  hi Search		guifg=#FDAD5D	guibg=#202880	gui=underline	ctermfg=215	ctermbg=18	cterm=underline
elseif s:SearchStandOut == 2
  hi IncSearch		guibg=#D0D0D0	guifg=#206828	gui=underline	ctermbg=252	ctermfg=22	cterm=underline
  hi Search		guibg=#FDAD5D	guifg=#202880	gui=underline	ctermbg=215	ctermfg=18	cterm=underline
endif

"------------------------------------------------------------------------------
" Specials:								   {{{4
"------------------------------------------------------------------------------
"
hi SignColumn		guifg=#00BBBB	guibg=#204d40
hi Special		guifg=#00E0F2	guibg=NONE	gui=NONE	ctermfg=45
hi SpecialKey		guifg=#00F4F4	guibg=#266955

"------------------------------------------------------------------------------
" Todo Variants:							   {{{4
"------------------------------------------------------------------------------
"
if s:TodoUnderline == 1
  " Underlined
  hi Todo		guifg=#AFD7D7	guibg=NONE	gui=underline	ctermfg=159	ctermbg=NONE	cterm=underline
else
  " Blue background
  hi Todo		guifg=#00FFFF	guibg=#0000FF			ctermfg=51	ctermbg=4
endif

"================================ Typographics =========================== {{{3
"
" Defines some common colors to be used for typographic entities.

"------------------------------------------------------------------------------
" Title Lines:								   {{{4
"------------------------------------------------------------------------------

hi tabulaTitle1		guifg=#FFFF00				 	ctermfg=226
hi tabulaTitle2		guifg=#FDAD85					ctermfg=216
hi tabulaTitle3		guifg=#D8AFAE					ctermfg=181
hi tabulaTitle4		guifg=#ACBCBC					ctermfg=250
hi tabulaTitle5		guifg=#87DA87					ctermfg=114
hi tabulaTitle6		guifg=#00D700					ctermfg=40
hi tabulaTitle7		guifg=#00DAD6					ctermfg=44
hi tabulaTitle8		guifg=#00AEFF					ctermfg=39
hi tabulaTitle9		guifg=#0088FF					ctermfg=33

"------------------------------------------------------------------------------
" Common Typographic Character Values:					   {{{4
"------------------------------------------------------------------------------

if s:CharValuesColored == 0
  hi tabulaBold		guifg=#87FFD7			gui=bold	ctermfg=122			cterm=bold
  hi tabulaItalic	guifg=#87D7EF			gui=italic	ctermfg=115			cterm=underline
  hi tabulaBoldItalic	guifg=#87FFD7			gui=bold,italic ctermfg=122			cterm=bold,underline
  hi tabulaItalicBold	guifg=#87D7EF			gui=bold,italic ctermfg=123			cterm=bold,underline
  hi tabulaUnderline    guifg=#87D7D7            	gui=underline	ctermfg=119			cterm=underline
  hi tabulaUnderlineItalic guifg=#87D7D7		gui=underline,italic ctermfg=121		cterm=underline
  hi tabulaBoldUnderline guifg=#87FFD7			gui=bold,underline ctermfg=119			cterm=bold,underline
  hi tabulaBoldUnderlineItalic guifg=#87D7EF		gui=bold,underline,italic ctermfg=121		cterm=bold,underline
elseif s:CharValuesColored == 1
  hi tabulaBold						gui=bold					cterm=bold
  hi tabulaItalic					gui=italic					cterm=reverse
  hi tabulaBoldItalic					gui=bold,italic 				cterm=bold,reverse
  hi tabulaItalicBold					gui=bold,italic 				cterm=bold,reverse
  hi tabulaUnderline            		    	gui=underline					cterm=underline
  hi tabulaUnderlineItalic 				gui=underline,italic 				cterm=underline,reverse
  hi tabulaBoldUnderline 				gui=bold,underline				cterm=bold,underline
  hi tabulaBoldUnderlineItalic				gui=bold,underline,italic			cterm=bold,underline,reverse
else
  hi tabulaBold						gui=bold					cterm=bold
  hi tabulaItalic					gui=italic					cterm=underline
  hi tabulaBoldItalic					gui=bold,italic 				cterm=bold,underline
  hi tabulaItalicBold					gui=bold,italic 				cterm=bold,underline
  hi tabulaUnderline            		    	gui=underline					cterm=reverse
  hi tabulaUnderlineItalic 				gui=underline,italic 				cterm=underline,reverse
  hi tabulaBoldUnderline 				gui=bold,underline				cterm=bold,reverse
  hi tabulaBoldUnderlineItalic				gui=bold,underline,italic			cterm=bold,underline,reverse
endif

"================================ Programming ============================ {{{3

"------------------------------------------------------------------------------
" Comment Colors:							   {{{4
"------------------------------------------------------------------------------
"
"hi Comment		guifg=#00C5E7					ctermfg=39	
hi Comment		guifg=#00C5E7					ctermfg=51

"------------------------------------------------------------------------------
" Constant Colors:							   {{{4
"------------------------------------------------------------------------------
"
if s:FlatConstants == 1
  hi Constant		guifg=#7DDCDB					ctermfg=123
else
  hi Boolean		guifg=#DD7E3A					ctermfg=123
  hi Character		guifg=#BFE000					ctermfg=148
  hi Float		guifg=#AF87DF					ctermfg=141
  hi Number		guifg=#0080FF					ctermfg=39
  hi String		guifg=#00DF50					ctermfg=46
endif

"------------------------------------------------------------------------------
" Preprocessor Variants:						   {{{4
"------------------------------------------------------------------------------
"
if s:ColorPre == "red"
  hi PreProc		guifg=#FF5F5F	guibg=bg			ctermfg=203
elseif s:ColorPre == "yellow"
  hi PreProc		guifg=#AFFF00	guibg=bg			ctermfg=154
elseif s:ColorPre == "blue"
  hi PreProc		guifg=#918EE4	guibg=bg			ctermfg=105
endif

"------------------------------------------------------------------------------
" Other Programming:							   {{{4
"------------------------------------------------------------------------------
"
if s:BoldStatement == 1
  hi Statement		guifg=#DEDE00			gui=bold	ctermfg=11			cterm=bold
else
  hi Statement		guifg=#E4E300			gui=NONE	ctermfg=11
endif

hi Identifier		guifg=#FDAE5A					ctermfg=215			cterm=NONE
hi Type			guifg=#F269E4	guibg=bg	gui=NONE	ctermfg=213

"------------------------------------------------------------------------------
" Language Specials:							   {{{4
"------------------------------------------------------------------------------
"
hi pythonPreCondit							ctermfg=2			cterm=NONE
hi tkWidget		guifg=#D5B11C	guibg=bg	gui=bold	ctermfg=7			cterm=bold
hi tclBookends		guifg=#7CFC94	guibg=NONE	gui=bold	ctermfg=2			cterm=bold

"==================================== HTML =============================== {{{3
"
" (see ':help html.vim' for more info)

let html_my_rendering=1

hi link htmlItalic		tabulaItalic
hi link htmlBold		tabulaBold
hi link htmlBoldItalic		tabulaBoldItalic
hi link htmlUnderline 		tabulaUnderline
hi link htmlUnderlineItalic	tabulaUnderlineItalic
hi link htmlBoldUnderline	tabulaBoldUnderline
hi link htmlBoldUnderlineItalic	tabulaBoldUnderlineItalic

hi htmlH1		guifg=#00FF00	guibg=NONE	gui=bold,underline ctermfg=2			cterm=bold,underline
hi htmlH2		guifg=#00FF00	guibg=NONE	gui=bold	ctermfg=2			cterm=bold
hi htmlH3		guifg=#00FF00	guibg=NONE	gui=NONE	ctermfg=2
hi htmlH4		guifg=#00C700	guibg=NONE	gui=underline	ctermfg=34			cterm=underline
hi htmlH5		guifg=#00C700	guibg=NONE	gui=NONE	ctermfg=34
hi htmlH6		guifg=#00A700	guibg=NONE	gui=underline	ctermfg=28			cterm=underline
hi htmlLink		guifg=#8787D7			gui=underline   ctermfg=105			cterm=underline

"================================== VimWiki ============================== {{{3
"
" (see: http://vim.sourceforge.net/scripts/script.php?script_id=2226)
" (:help vimwiki)

hi link wikiHeader1	tabulaTitle1
hi link wikiHeader2	tabulaTitle2
hi link wikiHeader3	tabulaTitle3
hi link wikiHeader4	tabulaTitle4
hi link wikiHeader5	tabulaTitle5
hi link wikiHeader6	tabulaTitle6

hi link wikiBold	tabulaBold
hi link wikiItalic	tabulaItalic
hi link wikiBoldItalic	tabulaBoldItalic
hi link wikiItalicBold	tabulaItalicBold

" TODO  Why does this not work?
"hi wikiLink		guifg=#00A700	guibg=NONE	gui=underline	ctermfg=28			cterm=underline

hi wikiEmoticons	guifg=#FF0000	guibg=#AFAF00	gui=bold	ctermfg=196	ctermbg=142

"================================ VimOutliner ============================ {{{3
"
" (see http://www.vimoutliner.org)
" Note: Make sure to add "colorscheme tabula" to the .vimoutlinerrc file.
"
"------------------------------------------------------------------------------
" Indent Level:								   {{{4
"------------------------------------------------------------------------------

hi link OL1	tabulaTitle1
hi link OL2	tabulaTitle2
hi link OL3	tabulaTitle3
hi link OL4	tabulaTitle4
hi link OL5	tabulaTitle5
hi link OL6	tabulaTitle6
hi link OL7	tabulaTitle7
hi link OL8	tabulaTitle8
hi link OL9	tabulaTitle9

"------------------------------------------------------------------------------
" Tags:									   {{{4
"------------------------------------------------------------------------------
"
hi outlTags		guifg=#F269E4					ctermfg=213
	
"------------------------------------------------------------------------------
" Body Text:								   {{{4
"------------------------------------------------------------------------------
"
hi BT1			guifg=#5FD75F					ctermfg=77 
hi BT2			guifg=#5FD75F					ctermfg=77
hi BT3			guifg=#5FD75F					ctermfg=77 
hi BT4			guifg=#5FD75F					ctermfg=77 
hi BT5			guifg=#5FD75F					ctermfg=77 
hi BT6			guifg=#5FD75F					ctermfg=77 
hi BT7			guifg=#5FD75F					ctermfg=77 
hi BT8			guifg=#5FD75F					ctermfg=77 
hi BT9			guifg=#5FD75F					ctermfg=77 

"------------------------------------------------------------------------------
" Preformatted Text:							   {{{4
"------------------------------------------------------------------------------
"
hi PT1			guifg=#7DDCDB					ctermfg=123
hi PT2			guifg=#7DDCDB					ctermfg=123
hi PT3			guifg=#7DDCDB					ctermfg=123
hi PT4			guifg=#7DDCDB					ctermfg=123
hi PT5			guifg=#7DDCDB					ctermfg=123
hi PT6			guifg=#7DDCDB					ctermfg=123
hi PT7			guifg=#7DDCDB					ctermfg=123
hi PT8			guifg=#7DDCDB					ctermfg=123
hi PT9			guifg=#7DDCDB					ctermfg=123

"------------------------------------------------------------------------------
" Tables:								   {{{4
"------------------------------------------------------------------------------
"
hi TA1			guifg=#918EE4	   				ctermfg=105
hi TA2			guifg=#918EE4	   				ctermfg=105
hi TA3			guifg=#918EE4	   				ctermfg=105
hi TA4			guifg=#918EE4	   				ctermfg=105
hi TA5			guifg=#918EE4	   				ctermfg=105
hi TA6			guifg=#918EE4	   				ctermfg=105
hi TA7			guifg=#918EE4	   				ctermfg=105
hi TA8			guifg=#918EE4	   				ctermfg=105
hi TA9			guifg=#918EE4	   				ctermfg=105

"------------------------------------------------------------------------------
" User Text Wrapping:							   {{{4
"------------------------------------------------------------------------------
"
hi UT1			guifg=#71D289					ctermfg=84
hi UT2			guifg=#71D289					ctermfg=84 
hi UT3			guifg=#71D289					ctermfg=84 
hi UT4			guifg=#71D289					ctermfg=84 
hi UT5			guifg=#71D289					ctermfg=84 
hi UT6			guifg=#71D289					ctermfg=84 
hi UT7			guifg=#71D289					ctermfg=84 
hi UT8			guifg=#71D289					ctermfg=84 
hi UT9			guifg=#71D289					ctermfg=84 
	
"------------------------------------------------------------------------------
" User Text Non Wrapping:						   {{{4
"------------------------------------------------------------------------------
"
hi UT1			guifg=#71D289					ctermfg=84 
hi UT2			guifg=#71D289					ctermfg=84 
hi UT3			guifg=#71D289					ctermfg=84 
hi UT4			guifg=#71D289					ctermfg=84 
hi UT5			guifg=#71D289					ctermfg=84 
hi UT6			guifg=#71D289					ctermfg=84 
hi UT7			guifg=#71D289					ctermfg=84 
hi UT8			guifg=#71D289					ctermfg=84 
hi UT9			guifg=#71D289					ctermfg=84

"================================== Txt2Tags ============================= {{{3
"
" Txt2tags is a universal text formatting and conversion tool
" (see: http://txt2tags.sf.net)
" TODO There are issues with the txt2tags syntax definitions so this must suffice.
"
hi link t2tTitle	tabulaTitle1
hi link t2tNumTitle	tabulaTitle1

hi link t2tComment	Comment
hi link t2tCommentArea	Comment

"=================================== Others ============================== {{{3
"
" colors for experimental spelling error highlighting
" this only works for spellfix.vim with will be cease to exist soon
"
hi spellErr		guifg=#E4E300			gui=underline	ctermfg=11			cterm=underline
hi BadWord		guifg=#E4E300			gui=underline	ctermfg=11			cterm=underline

"   endfunction	" End of TabulaMain function
" endif

"==============================================================================
"			       Options Processor			   {{{1
"==============================================================================
"
"------------------------------------------------------------------------------
" Main Dialog:								   {{{2
"------------------------------------------------------------------------------
"
function! Tabula()
  call inputsave()
  let thisOption = 1
  while thisOption >= 1 && thisOption <= 10
    redraw
    let thisOption = inputlist([
	  \		     "Select a 'Tabula_' option:",
	  \		     "1. BoldStatement      Display statements in bold",
	  \		     "2. ColorPre           Set Color for preprocessor statements",
	  \		     "3. CurColor           Set GUI cursor color",
	  \		     "4. DarkError          Use dark error background",
	  \		     "5. FlatConstants      Use multiple colors for constant values",
	  \		     "6. InvisibleIgnore    Display of Ignore and NonText characters",
	  \		     "7. LNumUnderline      Show line numbers underlined",
	  \		     "8. SearchStandOut     Display of search occurrences",
	  \		     "9. TodoUnderline      Display of TODOs and similar",
    	  \		     "10. CharValuesColored Display colored typographic character values"
	  \		     ])

    redraw
    if thisOption >= 1 && thisOption <= 10
      call Tabula_{thisOption}()
    endif
  endwhile
  call inputrestore()

"  NOTE: Removed, the colors still cannot be chnged on the fly.
"  call TabulaMain()
endfunction

"------------------------------------------------------------------------------
" Bold Statements:							   {{{2
"------------------------------------------------------------------------------
"
function! Tabula_1()
  let curOption = ""
  if s:BoldStatement == 0
    let curOption = "not "
  endif
  let optionValue = inputlist([
	\		      "How to display statements (currently ".curOption."bold)?",
	\		      "1. bold",
	\		      "2. not bold"
  	\		      ])
  if optionValue == 1
    let g:Tabula_BoldStatement = 1
  elseif optionValue == 2
    let g:Tabula_BoldStatement = 0
  endif
endfunction

"------------------------------------------------------------------------------
" Color For Preprocessor Statements:					   {{{2
"------------------------------------------------------------------------------
"
function! Tabula_2()
  let optionValue = inputlist([
	\		      "How to display preprocessor statements (currently ".s:ColorPre.")?",
	\		      "1. blue",
	\		      "2. red",
	\		      "3. yellow"
  	\		      ])
  if optionValue == 1
    let g:Tabula_ColorPre = "blue"
  elseif optionValue == 2
    let g:Tabula_ColorPre = "red"
  elseif optionValue == 3
    let g:Tabula_ColorPre = "yellow"
   endif
endfunction

"------------------------------------------------------------------------------
" GUI Cursor Color:							   {{{2
"------------------------------------------------------------------------------
"
function! Tabula_3()
  let optionValue = inputlist([
	\		      "Use which cursor color (currently ".s:CurColor.")?",
	\		      "1. blue",
	\		      "2. red",
	\		      "3. yellow",
  	\		      "4. white"
  	\		      ])
  if optionValue == 1
    let g:Tabula_CurColor = "blue"
  elseif optionValue == 2
    let g:Tabula_CurColor = "red"
  elseif optionValue == 3
    let g:Tabula_CurColor = "yellow"
  elseif optionValue == 4
    let g:Tabula_CurColor = "white"
  endif
endfunction

"------------------------------------------------------------------------------
" Use Dark Error Background:						   {{{2
"------------------------------------------------------------------------------
"
function! Tabula_4()
  let curOption = "light "
  if s:DarkError == 1
    let curOption = "dark "
  endif
  let optionValue = inputlist([
	\		      "How to display errors in the text (currently ".curOption."background)?",
	\		      "1. light background",
	\		      "2. dark background"
  	\		      ])
  if optionValue == 1
    let g:Tabula_DarkError = 0
  elseif optionValue == 2
    let g:Tabula_DarkError = 1
  endif
endfunction

"------------------------------------------------------------------------------
" Multiple Constant Colors:						   {{{2
"------------------------------------------------------------------------------
"
function! Tabula_5()
  let curOption = "one color"
  if s:FlatConstants == 0
    let curOption = "multiple colors"
  endif
  let optionValue = inputlist([
	\		      "How to display constant values (currently ".curOption.")?",
	\		      "1. use one common color for all",
	\		      "2. use different color for each type"
  	\		      ])
  if optionValue == 1
    let g:Tabula_FlatConstants = 1
  elseif optionValue == 2
    let g:Tabula_FlatConstants = 0
  endif
endfunction

"------------------------------------------------------------------------------
" Ignore And NonText Characters:					   {{{2
"------------------------------------------------------------------------------
"
function! Tabula_6()
  let curOption = "invisible"
  if s:InvisibleIgnore == 0
    let curOption = "slightly visible"
  endif
  let optionValue = inputlist([
	\		      "Show Ignore and NonText characters (currently ".curOption.")?",
	\		      "1. invisible",
	\		      "2. slightly visible"
  	\		      ])
  if optionValue == 1
    let g:Tabula_InvisibleIgnore = 1
  elseif optionValue == 2
    let g:Tabula_InvisibleIgnore = 0
  endif
endfunction

"------------------------------------------------------------------------------
" Underlined Line Numbers:						   {{{2
"------------------------------------------------------------------------------
"
function! Tabula_7()
  let curOption = ""
  if s:LNumUnderline == 0
    let curOption = "not "
  endif
  let optionValue = inputlist([
	\		      "How to display line numbers(currently ".curOption."underlined)?",
	\		      "1. underlined",
	\		      "2. not underlined"
  	\		      ])
  if optionValue == 1
    let g:Tabula_LNumUnderline = 1
  elseif optionValue == 2
    let g:Tabula_LNumUnderline = 0
  endif
endfunction

"------------------------------------------------------------------------------
" Let Search Occurrences Stand Out More Prominently:			   {{{2
"------------------------------------------------------------------------------
"
function! Tabula_8()
  if s:SearchStandOut == 0
    let curOption = "normal"
  elseif s:SearchStandOut == 1
    let curOption = "prominent"
  elseif s:SearchStandOut == 2
    let curOption = "very prominent"
  endif
  let optionValue = inputlist([
	\		      "How to display search occurrences (currently ".curOption.")?",
	\		      "1. normal",
	\		      "2. prominent",
	\		      "3. very prominent"
  	\		      ])
  if optionValue == 1
    let g:Tabula_SearchStandOut = 0
  elseif optionValue == 2
    let g:Tabula_SearchStandOut = 1
  elseif optionValue == 3
    let g:Tabula_SearchStandOut = 2
  endif
endfunction

"------------------------------------------------------------------------------
" TODOs Display:							   {{{2
"------------------------------------------------------------------------------
"
function! Tabula_9()
  let curOption = ""
  if s:TodoUnderline == 0
    let curOption = "not "
  endif
  let optionValue = inputlist([
	\		      "How to display TODOs and similar (currently ".curOption."underlined)?",
	\		      "1. underlined",
	\		      "2. not underlined"
  	\		      ])
  if optionValue == 1
    let g:Tabula_TodoUnderline = 1
  elseif optionValue == 2
    let g:Tabula_TodoUnderline = 0
  endif
endfunction

"------------------------------------------------------------------------------
" Typographic Character Values Display:					   {{{2
"------------------------------------------------------------------------------
"
function! Tabula_10()
  let curOption = "colored"
  if s:CharValuesColored == 1
    let curOption = "not colored, terminal italics reversed"
  elseif s:CharValuesColored == 2
    let curOption = "not colored, terminal underline reversed"
  endif
  let optionValue = inputlist([
	\		      "How to display bold, italic, underlined characters (currently ".curOption.")?",
	\		      "1. colored",
	\		      "2. not colored, terminal italics reversed",
  	\ 		      "3. not colored, terminal underline reversed"
  	\		      ])
  if optionValue == 1
    let g:Tabula_CharValuesColored = 0
  elseif optionValue == 2
    let g:Tabula_CharValuesColored = 1
  elseif optionValue == 3
    let g:Tabula_CharValuesColored = 3
  endif
endfunction

"==========================================================================}}}1
"

" vim:tw=0:fdm=marker:fdl=0:fdc=5:fen
