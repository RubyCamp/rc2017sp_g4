require 'dxruby'
require_relative "map_big"
require_relative "player_sprite_tamachang"

begin
  map = Map.new(File.join(File.dirname(__FILE__), "images", "map.dat"))
  player = PlayerSprite.new(0,0)
  current = map.start

  # DXRubyでは、Window.loopの処理の最後に描画が行われるため、
  # フラグ管理して描画がスキップされないようにする。
  init = true          # 初回のフレームかどうか
  reach_goal = false   # ゴールに到達したか
  give_up = false      # ゴール到達不可能になったかどうか

  Window.loop do
    break if Input.key_down? K_E
    if reach_goal
      puts "goal!"
      sleep 2
      break
    end
    if give_up
      puts "give up!"
      sleep 2
      break
    end
    if init
      init = false
    else
      route = map.calc_route(current, map.goal)
      if route.length == 1
        if current == map.goal
          reach_goal = true
        else
          give_up = true
        end
      else
        player.animation = true unless player.animation
        player.animation = false unless player.animate(route[1])
        player.draw
        #player.move_to(route[1])
        current = route[1] unless player.animation
      end
    end
    map.draw
    player.draw
  end
ensure
  player.close if player
end
