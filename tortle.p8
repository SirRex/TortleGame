pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- tortle game jam
-- by david d and joe l

--to do

    --add a baddie
    --give baddie 1 life
    --have baddie delete on death
    --respawn baddie after X seconds

player = nil
baddie = nil

function _init()

    player = make_player()

end

function _draw()

    cls()

    --for debugging sprite animation
	--spr(frame[1], 0,0, frame[2], 2)

    --background
    map(0,0,0,0,16,8)

    --player sprite (pre-animation)
    --spr(1,player.x,player.y,2,2)
    local offset = 0

    if player.flip and player.frame[2] > 2
        then offset = (player.frame[2] - 2)*8
    end

    spr(player.frame[1],player.x-offset,player.y,player.frame[2],2,player.flip)

    --for debugging sprite location for wall detection
    print("x "..player.x)
    print("y "..player.y)

end

function _update()

    player_movement(player)
    player_actions(player)
    player_animations(player)

end

function make_actor(x,y)

    local a = {}
    a.x = x
    a.y = y
    a.life = 1

    return a

end

function make_enemy()


end

function make_player()

    player = make_actor(78,112)
    player.score = 0
    player.flip = false

    --First variable is the # of the sprite; Second is the # of sprites wide; Third is the # of frames per animation (the wait between each animation)
    --for player animations
    player.anims = {
        idle = {
            {1, 2, 1}
        },
	    walk = {
		    {1, 2, 4},
		    {33, 2, 4},
		    {35, 2, 4},
		    {33, 2, 4}
	    },
    	sword = {
            {1, 2, 2},
            {3, 2, 3},
            {5, 3, 1},
            {8, 2, 2},
            {3, 2, 1}
	    }
    }

    -- The initial animation for the player is idle.
    player.currentAnim = player.anims.idle
    player.frameNum = 1
    player.frame = player.currentAnim[1]
    player.timer = player.currentAnim[1][3]

    return player

end

function player_movement(player)

    local movement = player

    if (btn(0)) then
        player.x = player.x-1
        player.currentAnim = player.anims.walk
        player.flip = true
    elseif (btn(1)) then
        player.x = player.x+1
        player.currentAnim = player.anims.walk
        player.flip = false
    elseif (btn(2)) then
        player.y = player.y-1
        player.currentAnim = player.anims.walk
    elseif (btn(3)) then
        player.y = player.y+1
        player.currentAnim = player.anims.walk
    elseif (player.currentAnim != player.anims.sword) then
        player.currentAnim = player.anims.idle
    end

    if player.y==63
        then player.y = player.y+1
    end
    if player.y==112
        then player.y = player.y-1
    end
    if player.x==-1
        then player.x = player.x+1
    end
    if player.x==113
        then player.x = player.x-1
    end

end

function player_actions(player)

    local actions = player

    if (btn(4)) then
        player.frameNum = 0
        player.currentAnim = player.anims.sword
    end

end

function player_animations(player)

    if (player.timer <= 0) then
		player.frameNum = (player.frameNum + 1) % #player.currentAnim
		player.frame = player.currentAnim[player.frameNum + 1]
		player.timer = player.frame[3]
	else
		player.timer -= 1
    end

    -- if the attack animation just finished, set the animation to idle.
    if (player.currentAnim == player.anims.sword) and (player.frameNum == 4) and (player.timer == 0) then
        player.currentAnim = player.anims.idle
    end

end



__gfx__
00000000000000111100000000000011110000000000001111000000000000000000001111000000000000000000000000000000000000000000000000000000
00000000000001333310000000000133331000000000013333100000000000000000013333100077000000000000000000000000000000000000000000000000
00700700000001375311000000000137531100000000013753110000000000000000013753110770000000000000000000000000000000000000000000000000
00077000000001333331000000000133333100000000013333310000000000000000013333317500000000000000000000000000000000000000000000000000
00077000000014111110000000001411111000000000141111103777777700000000141111175000000000000000000000000000000000000000000000000000
00700700000124444990000000012444499000000001244449937777777777000001244449950000000000000000000000000000000000000000000000000000
00000000000142443999000000014244399900000001424439993077777777770001424439990000000000000000000000000000000000000000000000000000
00000000001444233999000000144423399900000014442339990007777777770014442339990000000000000000000000000000000000000000000000000000
00000000001222333999000000122233399330000012223339990000777777700012223339990000000000000000000000000000000000000000000000000000
00000000001444433559000000144443353330000014444339990000777777700014444335590000000000000000000000000000000000000000000000000000
00000000001444233344000000144423333330000014442333440777777777000014442333440000000000000000000000000000000000000000000000000000
00000000000142473340000000014247334000000001477733777777777700000001424233400000000000000000000000000000000000000000000000000000
00000000000124772240000000012477224000000001244777777777770000000001244244400000000000000000000000000000000000000000000000000000
00000000000017722331000000001772233100000000133223310000000000000000133243310000000000000000000000000000000000000000000000000000
00000000000077311333100000007731133310000000133113331000000000000000133113331000000000000000000000000000000000000000000000000000
00000000000133310133310000013331013331000001333101333100000000000001333101333100000000000000000000000000000000000000000000000000
00000000000000111100000000000011110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000001333310000000000133331000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000001375311000000000137531100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000001333331000000000133333100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000014111110000000001411111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000124444990000000012444499000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000142443999000000014244399900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001444233999000000144423399900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001222333999000000122233399900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001444433559000000144443355900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001444233344000000144423334400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000142473340000000014247334000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000124772240000000012477224000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000017722331000000001772233100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000077311331000000007731133310000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000001333131000000013331013331000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddddddddd55555554444444444444444000000000000000002444420000000000000000000000000000000000000000000000000000000000000000000000000
d5555555d55555554f4ff4f44f4ff4f4000000000000000054444445000000000000000000000000000000000000000000000000000000000000000000000000
5dd55555dddddddd0444444004444440000000000000000054ffff45000000000000000000000000000000000000000000000000000000000000000000000000
555d55555555d555000000000004400000000000000000005f2222f5000000000000000000000000000000000000000000000000000000000000000000000000
dddddddd5555d5550000000000044000000000000000000052444425000000000000000000000000000000000000000000000000000000000000000000000000
555555d5dddddddd0000000000044000000000000000000054444445000000000000000000000000000000000000000000000000000000000000000000000000
d555555dd55555550000000000044000000000000000000054ffff45000000000000000000000000000000000000000000000000000000000000000000000000
5dd55555d5555555000000000004400000000000000000005f2222f5000000000000000000000000000000000000000000000000000000000000000000000000
00000000d555555d0000000000044000000000000000000052444425000000000000000000000000000000000000000000000000000000000000000000000000
000000005d5555d50000000000044000000000000000000054444445000000000000000000000000000000000000000000000000000000000000000000000000
000000005d5555d50000000000044000000000000000000054ffff45000000000000000000000000000000000000000000000000000000000000000000000000
00000000d555555d000000000004400000000000000000005f2222f5000000000000000000000000000000000000000000000000000000000000000000000000
00000000d555555d0000000000044000000000000000000052444425000000000000000000000000000000000000000000000000000000000000000000000000
000000005d5555d50000000000044000000000000000000054444445000000000000000000000000000000000000000000000000000000000000000000000000
000000005d5555d50000000000044000000000000000000054ffff45000000000000000000000000000000000000000000000000000000000000000000000000
00000000d555555d000000000004400000000000000000005f2222f5000000000000000000000000000000000000000000000000000000000000000000000000
000000000d5555d00000000000000000000000000000000014444441144444411444444100000000000000000000000000000000000000000000000000000000
00000000d5dddd5d0000000000000000000000000000000001111110211111122111111200000000000000000000000000000000000000000000000000000000
000000005d5555d50000000000000000000000000000000000000000f222222ff222222f00000000000000000000000000000000000000000000000000000000
000000005d5555d50000000000000000000000000000000000000000ffffffffffffffff00000000000000000000000000000000000000000000000000000000
000000005d5555d50000000000000000000000000000000000000000ffff555fffffffff00000000000000000000000000000000000000000000000000000000
000000005d5555d50000000000000000000000000000000000000000f555ffffffffffff00000000000000000000000000000000000000000000000000000000
00000000d5dddd5d0000000000000000000000000000000000000000ffffffffffffffff00000000000000000000000000000000000000000000000000000000
000000000d5555d00000000000000000000000000000000000000000ffffffffffffffff00000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000fffffffffffff55fffffffffff4444ff0000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000fffffffffffffffffffffffff442244f0000000000000000000000000000000000000000
00000000000008000000000000000000000000000000000000000000f5f5fffffffffffffffffffff422224f0000000000000000000000000000000000000000
0000000008000d000000000000000000000000000000000000000000ff5ffffffffffffffffffffff422224f0000000000000000000000000000000000000000
0000000008008d000000000000000000000000000000000000000000fffffffffffffffffffffffff444494f0000000000000000000000000000000000000000
000000000dd0ddd00000000000000000000000000000000000000000fffffffffffffffffffffffff422224f0000000000000000000000000000000000000000
00000000ddd0ddd00000000000000000000000000000000000000000fffffffffffffffffffffffff422224f0000000000000000000000000000000000000000
00000000000cc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000c77c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000cccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000cccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000007cccc700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000007cccccc70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000007cccccc70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000077777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000098000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8696969696969686000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a7a8a7a8a7a8a8a7869696969696968600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b8b9b7b9838283b7a8a7a7a8a8a7a8a800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b7b8b9ba93a293b9bab7b8b9b7bab9b900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8181818181808181818181818181818100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8181818081818181818180818181818100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
8181818181818181818181818181818100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
