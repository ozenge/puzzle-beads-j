toFloat =: _1&(3!:5)
fromFloat =: 1&(3!:5)
atan2 =: ((180%1p1)*[:12&o.j./)"1
rnd =: [*[:<.0.5+%~
swap =: {{|.&.((<"_1 x)&{)y}}
pick =: ([:?#){]
upto =: <.+([:i.[:>:[:|-)

rc =: ('etc\librlptr.dll ',[)cd]
(9!:1)6!:14".6!:0'YYYYMMDDhhmmsssss'

InitWindow =: 'InitWindow n i i *c'&rc
CloseWindow =: 'CloseWindow n'&rc
BeginDrawing =: 'BeginDrawing n'&rc :.EndDrawing
EndDrawing =: 'EndDrawing n'&rc
ClearBackground =: {{
	cp =. Color_a y
	'wrapped_ClearBackground n i'rc cp
	memf cp}}
DrawCircleV =: {{
	'ct r c' =. y
	ctp =. Vector2_a ct[cp =. Color_a c
	'wrapped_DrawCircleV n i f i'rc ctp;r;cp
	memf ctp[memf cp}}
DrawCircleSector =: {{
	'ct r sa ea s c' =. y
	ctp =. Vector2_a ct[cp =. Color_a c
	'wrapped_DrawCircleSector n i f f f i i'rc ctp;r;sa;ea;s;cp
	memf ctp[memf cp}}
DrawLineEx =: {{
	's e t c' =. y
	sp =. Vector2_a s[ep =. Vector2_a e[cp =. Color_a c
	'wrapped_DrawLineEx n i i f i'rc sp;ep;t;cp
	memf sp[memf ep[memf cp}}
IsMouseButtonPressed =: 'IsMouseButtonPressed > b i'&rc
IsMouseButtonDown =: 'IsMouseButtonDown > b i'&rc
IsMouseButtonReleased =: 'IsMouseButtonReleased > b i'&rc
WindowShouldClose =: 'WindowShouldClose > b'&rc
SetTraceLogLevel =: 'SetTraceLogLevel n i'&rc
GetMousePosition =: {{Vector2_r'wrapped_GetMousePosition *'rc''}}

Vector2_r =: {{
	p =. >{.y
	r =. toFloat memr p,0 8
	echo r
	r[memf p}}
Color_a =: {{
	p =. mema 4
	p[(y{a.)memw p,0 4}}
Vector2_a =: {{
	p =. mema 8
	p[(fromFloat y)memw p,0 8}}
C =: 255,~[:(3$256)&#:[:".'16b'&,

w =: [h =: 512
ct =: -:w,h
ir =: h%8

init_pz =: (0,7$_1),3 8$1+i.8
mix_pz =: {{
	mix =. {{
		cr =. (([:<[:,/2&{.),([:<"(0)2&}.))i.#y
		if. ?2 do.
			'zi zj' =. ($y)#:(,y)i.0
			ci =. ((0&<*.<&(#y))#])(zi-1),zi+1
			y swap~(zj,~pick ci),:zi,zj
			else.
			((?#y)&|.)"1&.((>pick cr)&{)y
			end.
		}}
	mix^:x y}}
rw =: -:(#init_pz)%~h-+:ir
cs =: '000000','e6194b','f58231','ffe119','3cb44b','42d4f4','4363d8','911eb4',:'f032e6'
click_pz =: {{
	if. 0>:(<x){y do. y return. end.
	'xi xj' =. x
	'zi zj' =. ($y)#:(,y)i.0
	if. xj=zj do. |:(((*xi-zi)&|.)&.((xi upto zi)&{)xj{|:y) xj}|:y else. y end.}}
draw_pz =: {{
	x0 =. x
	for_i. |.i.#y do.
		DrawCircleV ct;(ir+rw*>:i);255,~3$127+60*(i=0)+.i|~2
		for_j. i.{:$y do.
			if. 0>(<i,j){y do. continue. end.
			rr =. +.r.((1p1%180)*i{x)+j*2p1%{:$y
			DrawLineEx ct;(ct+rr*ir+rw*>:i);rw;C'000000'
			DrawCircleV(ct+rr*ir+rw*0.5+i);(-:rw);C cs{~y{~<i,j
			end.
		DrawCircleV ct;(ir+rw*i);C'ffffff'
		end.}}

main =: {{
	SetTraceLogLevel 7
	InitWindow w;h;'puzzle beads'
	pz =. 500 mix_pz init_pz
	aa =. 0$~#init_pz
	ai =. ''
	a0 =. [a1 =. 0
	while. -.WindowShouldClose'' do.
		if. IsMouseButtonPressed 0 do.
			i =. <.rw%~(|j./ct-~GetMousePosition'')-ir
			if. (0<:i)*.i<#pz do.
				for_j. i.{:$pz do.
					if. (-:rw)>:|j./(ct+(+.r.j*2p1%{:$pz)*ir+rw*0.5+i)-~GetMousePosition'' do.
						pz =. pz click_pz~i,j
						break.
						end.
					end.
				ai =. ,({{0 1}}`])@.(i>1)i
				a0 =. atan2 ct-~GetMousePosition''
				end.
			end.
		if. (#ai)*.IsMouseButtonDown 0 do.
			a1 =. atan2 ct-~GetMousePosition''
			aa =. (a1-a0)ai}aa
			end.
		if. (#ai)*.IsMouseButtonReleased 0 do.
			aa =. 0 ai}aa
			pz =. ((-1 rnd 45%~a1-a0)|."1 ai{pz)ai}pz
			ai =. ''
			end.
		BeginDrawing''
		ClearBackground C'ffffff'
		aa draw_pz pz
		EndDrawing''
		end.
	CloseWindow''
	exit''}}
main''