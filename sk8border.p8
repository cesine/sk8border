pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

-- constants
tpb=16 // ticks per beat
lst=16*tpb // loopstart tick
let=lst+176*tpb // loopend tick
early = 8 // early display ticks
v1_recur = {0, 32*tpb}
lyrics = {
 {"♪we're gonna take♪",
  -- span of time to display
  {32*tpb, 36*tpb},
  -- list of time offsets for
  -- recurring display
  v1_recur},
 {"♪down that wall♪",
  {36*tpb, 39*tpb},
  v1_recur},
 {"♪down that wall♪",
  {40*tpb, 43*tpb},
  v1_recur},
 {"♪down that wall♪",
  {44*tpb, 46.5*tpb},
  v1_recur},
 {"♪break it!♪",
  {46.5*tpb, 49*tpb},
  v1_recur},
 {"♪we will tear♪",
  {49*tpb, 52*tpb},
  v1_recur},
 {"♪down that wall♪",
  {52*tpb, 56*tpb},
  v1_recur},
 {"♪that wall is comin down♪",
  {56*tpb, 60*tpb},
  v1_recur},
 {"*interlude harmonique*",
  {96*tpb, 112*tpb},
  {0}},
}

keys = {
 left=0,
 right=1,
 up=2,
 down=3,
 a=4,
 b=5
}

  -- acceleration due to gravity
g = 0.6

-- end constants


-- global variables
t = nil
player = nil

-- end global variables


function make_player(x,y)
  local p = {}
  p.x = x
  p.y = y
  p.dy = 0
  p.ddy = g  -- acceleration due to gravity
  return p
end


function update_player(p)
  if (btn(keys.left)) then p.x -= 1 end
  if (btn(keys.right)) then p.x += 1 end

  -- vertical motion with simplistic gravity
  if (btn(keys.up) or btn(keys.a)) then
    p.dy = 0 -- reset falling from gravity
    p.y -= 1
  else
    apply_gravity(p)
  end 
end


function apply_gravity(p)
  if (p.y < 36) then
    p.dy += p.ddy
    p.y += p.dy
  else
    p.dy = 0 -- we are on the ground
  end
end


function drawskater(p)
  spr(80,p.x,p.y-24,2,3)
end


function _init()
  t = 0
  player = make_player(0,36)
 
  music(0)
 
  palt(0,false)
  palt(7,true)
end


function _draw()
  cls()
  rectfill (0,0,127,127,12)
  mapdraw()
  drawskater(player)
  spr(11,9*8,12*8,4,3)
  palt(0,true)
  palt(7,false)
  spr(1,48,24,4,1)
  palt(0,false)
  palt(7,true)

 -- lyric cursor
  local lc =
    --(t-lst)%(let-lst) + early
    (t-lst)+early //verse 1 only

  for _,lyric in pairs(lyrics)
  do
    for _,off in pairs(lyric[3])
    do
      if
        lc >= lyric[2][1] + off and
        lc < lyric[2][2] + off then
          text = lyric[1]
          print(
            text,
            8*8 - (#text*4)/2,
            8,
            7
          )
          break
      end
    end
  end
end


function _update60()
  update_player(player)

  if (btn(4)) then
    // if z is pressed...
    sfx(19) // test explosion
  end
  t = t + 1
end

__gfx__
00000000000000000000000000000000000000007000000000000000000000000000000700000000000000007777777777777777777777777777777700000000
000000000000000777777777770000000000000005666666666666666666555566666660ffffffff000000007777777777777770077777777777777700000000
007007000000007777777777777000000000000001565656565656565656151556565660ffffffff00000000777777777777770ff07777777777777700000000
000770000000007777777777777000000000000001555555555555555555111155555560ffffffff0000000077777777777770ffff0777777777777700000000
000770000777777777777777777777000000000001555555555555555555111155555560ffffffff000000007777777777770ffffff077777777777700000000
0070070077777777777777777777777777777700015555555555555555551111555555604444444400000000777777777770ffffffff07777777777700000000
000000007777777777777777777777777777777001555555555555555555111155555560444444440000000077777777770ffffffffff0777777777700000000
00000000077777777777777777777777777777000155555555555555555511115555556044444444777777777777777770fffff44fffff077777777700000000
0000000000000000000000000000000000000000015555555555555555551111555555604444444400000000777777770fffff4444fffff07777777700000000
00000000000000000000000000000000000000000155555555555555555511115555556044444444ffffffff77777770fffff4ffff4fffff0777777700000000
00000000000000000000000000000000000000000155555555555555555511115555556044444444ffffffff7777770fffff44444444fffff077777700000000
00000000000000000000000000000000000000000155555555555555555511115555556044444444ffffffff777770fffff4ffffffff4fffff07777700000000
00000000000000000000000000000000000000000155555555555555555511115555556044444444ffffffff77770fffff4ffffffffff4fffff0777700000000
00000000000000000000000000000000000000000155555555555555555511115555556044444444444444447770fffff44444444444444fffff077700000000
0000000000000000000000000000000000000000015555555555555555551111555555604444444444444444770fffff4444444444444444fffff07700000000
000000000000000000000000000000000000000001555555555555555555111155555560444444444444444470fffff444444444444444444fffff0700000000
00000000000000000000000000000000000000000155555555555555555511115555556000000000000000000fffff44444444444444444444fffff000000000
0000000000000000000000000000000000000000015555555555555555551111555555600000bbbbbbbbbb00fffff4444444444444444444444fffff00000000
000000000000000000000000000000000000000001555555555555555555111155555560000000333333aaa0ffff444444444444444444444444ffff00000000
0000000000000000000000000000000000000000015555555555555555551111555555600000000991a1aaa0fff44444444444444444444444444fff00000000
0000000000000000000000000000000000000000015555555555555555551111555555600000000099999990ff4444444444444444444444444444ff00000000
00000000000000000000000000000000000000000155555555555555555511115555556000099922222000004444444444444444444444444444444400000000
00000000000000000000000000000000000000000155555555555555555511115555556000000022e2e229904444444444444444444444444444444400000000
00000000000000000000000000000000000000000566666666666666666655556666666000000002eee220004444444444444444444444444444444400000000
000000000000000000000000000000000000000001555555555555555555111155555560000000222e2000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000155555555555555555511115555556000006666666660000000000000000000000000000000000000000000
00000000000000000000000000000000000000000155555555555555555511115555556000066655000666000000000000000000000000000000000000000000
00000000000000000000000000000000000000000566666666666666666655556666666000644400000444080000000000000000000000000000000000000000
00000000000000000000000000000000000000000155555555555555555511115555556088888888888888800000000000000000000000000000000000000000
00000000000000000000000000000000000000000566666666666666666655556666666000a000000000a0000000000000000000000000000000000000000000
00000000000000000000000000000000000000000566666666666666666655556666666000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000566666666666666666655556666666000000000000000000000000000000000000000000000000000000000
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777700000000000000000000000000000000
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777700000000000000000000000000000000
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777700000000000000000000000000000000
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777700000000000000000000000000000000
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777700000000000000000000000000000000
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777700000000000000000000000000000000
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777700000000000000000000000000000000
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777700000000000000000000000000000000
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777700000000000000000000000000000000
77777777777777777777777777777777777777000077777777777777777777777777777777777777777777777777777700000000000000000000000000000000
77777777777777777777777777777777777770888007777777777777777777777777777777777777777777777777777700000000000000000000000000000000
77777777777777777777777777777777777770880407777777777777777777777777777777777777777777777777777700000000000000000000000000000000
77777777777777777777777777777777777770880407777777777777777777777777777777777777777777777777777700000000000000000000000000000000
77777777777777777777777777777777777770880907777777777777777777777777777000007777777770000077777700000000000000000000000000000000
77777700000777777777777777777777777770880907777777777777777777777777770888880777777708888800007700000000000000000000000000000000
77777088888077777777777777777777770000888000007777777777777777777700770888880777777708888804990700000000000000000000000000000000
77777088800077777777777777777777709948888884490777777700000777777099000880000777777708800000007700000000000000007777770000077777
77777088044077777777777777777777709000888800090777777088888077777704488804440777777708044407777700000000000000007777708888807777
77777708099077777777777777777777709070888807090777777088800077777770000809907777777708099077777700000000000000007777708880007777
77777708099077777777777777777777770770888807707777777088044077777777770880000777770008800077777700000000000000007777708804407777
77000008800000077777700000000777777770888807777777777708099077777777770888888007704488888077777700000000000000007777770809907777
70994888888844907777088888888077777770666607777777000008099000077777770888800990099008888077777700000000000000007700000800000007
77000088880000077777088880000077777770660d07777770994888800844907770000888807007000708888000077700000000000000007099488888884490
77777088880777777000088809999007777770660d07777777000088880000077706666666607777777706666666607700000000000000007700008888000007
77777088880077770994888800000490777770660d07777777777088880777777006dd000d660777777066d000dd600700000000000000007777708888077777
77770666666607777000088888880007777706660dd0777777770088880007770880007770d6077777706d077700088000000000000000007777008888000777
777066d000d660777706666666666607777706660dd0777777706666666660777008800770d6607777706d077008800700000000000000007770666666666077
77066d07770d660770666dd00000d660777706660dd0777777066dd0000d660770a00880070d60777706d07008800a07000000000000000077066dd0000d6607
7066d077770d660770666d077770d66077777000000777777066d007770d660777077008800d60777706d0088007707700000000000000007066d007770d6607
00000000000000000000000000000000000000000000000000000000000000007777777008800077770008800777777700000000000000000000000000000000
08888888888888800888888888888880088888888888888008888888888888807777777770088077770880077777777700000000000000000888888888888880
70a000000000a00770a000000000a00770a000000000a00770a000000000a00777777777770a07777770a07777777777000000000000000070a000000000a007
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0506060606060800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516161616161800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516161616161805060606080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516161616161815161616180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516161616161815161616180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516161616161815161616180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1516161616161815161616180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2526262626262825262626280000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3536363636363835363636380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0909090909090909090909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1919191919191919191919191919191900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
01040000072500c250072500c25000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000047500005004750000503475000050347500005024750247500005014700147500005014750000500475000050047500005034750000503475000050247502475000050147001475000050147500005
01100000182511825118251182511b2511b2511b2511b2511b2511b2511b2511b2511b2511b2511b2511b250182511825118251182511e2511e2511e2511e2511e2511e2511e2511e2511e2511e2511e2511e250
011000001b2511b2511b2511b2512225122251222512225122251222512225122251222512225122251222501d2551e2551e2002b8751f2001f2551f2551f2551d2551e2551e2002b8751f2001e2551d2551b255
011000000047500005004750000503475034050347500005024750247500005014700147500005014750000500475064750640007475034050000503405000050547506475064000747507400064750547503475
011000000047500005004750000503475034050347500005024750247502405014700147501400014050140500475000050047500005034750000503475000050247502475000050147501405064700647006470
01100000074750c000074750000508475000050747500005084750647500005074700747500005014750000508475064750020007475130000747507400004750040502404000050147001470014700147001470
0110000018250182001b2501b2001f250182001820018200202501e250182001f25018200182001820018200202501e250182001f25018200182001820018200202501e250182001f2501f200308501d20030850
01100000182001820018250182001b2501b2001f25018200202501e250182001f25018200182001820018200202501e250182001f25018200172501820018250202001e200182001f2001f200242001d20024200
011000000747500005074750000508475000050747500005084750647500005074700747500005014750000508475064750020007475002000747500200004750240002400000000140001400000000140020200
010800002e2422b24228242252422e2422b24228242252422e2422b24228242252422e2422b24228242252422e2422b24228242252422e2422b24228242252422e2422b24228242252422e2422b2422824225242
010800002d2422a24227242242422d2422a24227242242422d2422a24227242242422d2422a24227242242422c2222922226222232222c2222922226222232222c2222c20226200232002c200292002620023200
010800201647513475104750d4751647513475104750d4751647513475104750d4751647513475104750d4751647513475104750d4751647513475104750d4751647513475104750d4751647513475104750d475
0108000015465124650f4650c46515465124650f4650c46515465124650f4650c46515465124650f4650c46514455114550e4550b45514455114550e4550b4551440011400014700147001470014700147001470
011000001830018300183501b3501e3501f3501830018300183501b3501e3501f35018300183001830018300183001b300183501b3501e3501f3501d3501b3501d3501e300183001f3001f300183001d30018300
01100000183001830017350183501a3501d350183001830017350183501a3501d350183001830018300183001e3501f3501e3501f3501e3501d3501b3501a3501b350181501b1501e1501f150181001f15018300
011000001b15018150183501b3501e3501f3501830018300183501b3501e3501f35018300183001830018300183001b300183501b3501e3501f3501d3501b3501d3501e300183001f3001f300183001d30018300
01100000183001830017350183501a3501d3501535016350173501a3501735013350183001830018300183001e3001f300123501335014350153501635017350183501e300183001f30030800183001d30018300
010800200c655006050c6550c6050c6550060524655006050c655006050c6551860524655006050c655006050c655006050c6550c6550c6550060524655006050c655006050c6551860524655006050c65500605
0002000037335170353d33517035170352f635150353b3353d63512035373353433511035396352f3350e0352f635253352e6350c0351933529635123353063525635013353363527635286353b6351f63531635
011000000047500005004750000503475034050347500005024750247502405014700147501400014750140500475000050047500005034750000503475000050247502475000050147501405064700647006470
__music__
00 01421244
01 01021244
00 04031244
00 05071244
00 06081244
00 14071244
00 09081244
00 0c0a1244
00 0d0b1244
00 050e1244
00 060f1244
00 14101244
02 09111244
00 4142524c
00 44435244

