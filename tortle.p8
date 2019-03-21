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
enemy = nil

actors = {
}

states = {
    idle = 1,
    walking = 2,
    attacking = 3
}

function _init()

    add (actors,make_enemy(32,32))
    add (actors,make_enemy(32,64))
    add (actors,make_enemy(32,96))
    player = make_player()
    enemy = make_enemy()

end

function _draw()

    cls()

    --background
    map(0,0,0,0,16,8)

    local offset = 0

    if ((not player.facingRight) and player.frame.width > 2)
        then offset = (player.frame.width - 2)*8
    end

    spr(player.frame.sprite,player.position.x-offset,player.position.y,player.frame.width,2,not player.facingRight)

    for actor in all (actors) do
        spr(37,actor.position.x,actor.position.y,2,2)
    end

    --for debugging sprite location for wall detection
    print("x "..player.position.x)
    print("y "..player.position.y)
    print("state "..player.state)

end

function _update()

    player_input(player)
    player_movement(player)
    player_actions(player)
    player_animations(player)

end

function make_actor(x,y)

    local a = {}
    a.position = vec2(x, y)
    a.life = 1

    return a

end

function make_enemy(x,y)


    enemy = make_actor(x,y)

    return enemy

end

function make_player()

    player = make_actor(0,90)
    player.score = 0

    -- First variable is the # of the sprite; Second is the # of sprites wide; Third is the # of frames per animation (the wait between each animation)
    -- for player animations
    player.anims = {
        idle = {
            make_frame(1, 2, 1)
        },
	    walk = {
		    make_frame(1, 2, 4),
		    make_frame(33, 2, 4),
		    make_frame(35, 2, 4),
		    make_frame(33, 2, 4)
	    },
    	sword = {
            make_frame(1, 2, 2),
            make_frame(3, 2, 3),
            make_frame(5, 3, 1),
            make_frame(8, 2, 2),
            make_frame(3, 2, 1, player_attackEnd)
	    }
    }

    -- The initial animation for the player is idle.
    player.currentAnim = player.anims.idle
    player.frameNum = 1
    player.frame = player.currentAnim[1]
    player.timer = player.currentAnim[1].duration

    -- idle, walking, attacking
    player.state = states.idle
    player.facingRight = true
    player.direction = vec2(0, 0)

    return player

end

function player_input(player)
    player.direction = vec2(0, 0)

    if (player.state != states.attacking) then
        player.state = states.idle

        if (btn(0)) then
            player.direction.x += -1
            player.state = states.walking
            player.facingRight = false
        end

        if (btn(1)) then
            player.direction.x += 1
            player.state = states.walking
            player.facingRight = true
        end

        if (btn(2)) then
            player.direction.y += -1
            player.state = states.walking
        end

        if (btn(3)) then
            player.direction.y += 1
            player.state = states.walking
        end
    end

end

function player_movement(player)

    if player.state == states.walking then
        player.position = vec2add(player.position, player.direction)
    end

    if player.position.y==63
        then player.position.y = player.position.y+1
    end
    if player.position.y==112
        then player.position.y = player.position.y-1
    end
    if player.position.x==-1
        then player.position.x = player.position.x+1
    end
    if player.position.x==113
        then player.position.x = player.position.x-1
    end
end

function player_actions(player)

    local actions = player

    if (btn(4)) then
        player.state = states.attacking
    end

end

function player_animations(player)

    if player.state == states.walking then
        player.currentAnim = player.anims.walk
    end
    if player.state == states.attacking then
        player.currentAnim = player.anims.sword
    end
    if player.state == states.idle then
        player.currentAnim = player.anims.idle
    end

    if (player.timer <= 0) then
        
        if (player.frame.finishedCallback != nil) then
            player.frame.finishedCallback(player)
        end

		player.frameNum = (player.frameNum + 1) % #player.currentAnim
		player.frame = player.currentAnim[player.frameNum + 1]
		player.timer = player.frame.duration
	else
		player.timer -= 1
    end

    -- if the attack animation just finished, set the animation to idle.
    if (player.currentAnim == player.anims.sword) and (player.frameNum == 4) and (player.timer == 0) then
        player.currentAnim = player.anims.idle
    end

end

function player_attackEnd(player)
    player.state=states.idle
end

-- Utility functions

function vec2(x, y)
    return {x=x, y=y}
end

function vec2add(v1, v2)
    return vec2(v1.x + v2.x, v1.y + v2.y)
end

function make_frame(sprite, width, duration, finishedCallback)
    return {sprite = sprite, width = width, duration = duration, finishedCallback = finishedCallback}
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
00000000000142443999000000014244399900000000060000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001444233999000000144423399900000000070000670000000006000000000000000000000000000000000000000000000000000000000000000000
00000000001222333999000000122233399900000760076006700070000007000067000000000000000000000000000000000000000000000000000000000000
00000000001444433559000000144443355900000076876867700760076007600670007000000000000000000000000000000000000000000000000000000000
00000000001444233344000000144423334400000007688888867600007687686770076000000000000000000000000000000000000000000000000000000000
00000000000142473340000000014247334000000088888888886000000768888886760000000000000000000000000000000000000000000000000000000000
00000000000124772240000000012477224000000088888888888500008888888888600000000000000000000000000000000000000000000000000000000000
00000000000017722331000000001772233100000599950000599950008888888888850000000000000000000000000000000000000000000000000000000000
00000000000077311331000000007731133310000599950000599950059995000059995000000000000000000000000000000000000000000000000000000000
00000000000001333131000000013331013331000055500000055500005550000005550000000000000000000000000000000000000000000000000000000000
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
