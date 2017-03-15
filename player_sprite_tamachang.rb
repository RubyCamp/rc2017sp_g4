require_relative 'player_big'

class PlayerSprite < Sprite
  attr_accessor :animation

  def initialize(x, y, image = nil)
    image = Image.load("images/tamachang_big.png")
    image.set_color_key([255,255,255])
    super
    self.angle = 0
    @cell_x = x % self.image.width
    @cell_y = y % self.image.height
    #@player = Player_big.new("COM6")
  end

  def run_forward
    case self.angle
    when 0
      self.x += self.image.width
      @cell_x += 1
    when 90
      self.y += self.image.height
      @cell_y += 1
    when 180
      self.x -= self.image.width
      @cell_x -= 1
    when 270
      self.y -= self.image.height
      @cell_y -= 1
    else
      raise "invalid angle"
    end
    @player.run_forward
  end

  def run_backward
    case self.angle
    when 0
      self.x -= self.image.width
      @cell_x -= 1
    when 90
      self.y -= self.image.height
      @cell_y -= 1
    when 180
      self.x += self.image.width
      @cell_x += 1
    when 270
      self.y += self.image.height
      @cell_y += 1
    else
      raise "invalid angle"
    end
    @player.run_backward
  end

  def turn_right
    self.angle += 90
    adjust_angle
    @player.turn_right
  end

  def turn_left
    self.angle -= 90
    adjust_angle
    @player.turn_left
  end

  def close
    @player.close if @player
  end

  def move_to(target_cell)
    return unless movable?(target_cell)
    dx = target_cell[0] - @cell_x
    dy = target_cell[1] - @cell_y
    if dx == 1
       case self.angle
       when 0
         run_forward
       when 90
         turn_left
         run_forward
       when 180
         run_backward
       when 270
         turn_right
         run_forward
       else
         raise "invalid angle"
       end
    elsif dx == -1
       case self.angle
       when 0
         run_backward
       when 90
         turn_right
         run_forward
       when 180
         run_forward
       when 270
         turn_left
         run_forward
       else
         raise "invalid angle"
       end
    elsif dy == 1
       case self.angle
       when 0
         turn_right
         run_forward
       when 90
         run_forward
       when 180
         turn_left
         run_forward
       when 270
         run_backward
       else
         raise "invalid angle"
       end
    elsif dy == -1
       case self.angle
       when 0
         turn_left
         run_forward
       when 90
         run_backward
       when 180
         turn_right
         run_forward
       when 270
         run_forward
       else
         raise "invalid angle"
       end
    end
  end

  def movable?(target_cell)
    return false if @animation
    dx = target_cell[0] - @cell_x
    dy = target_cell[1] - @cell_y
    return (dx ** 2 + dy ** 2) == 1
  end

  def animate(destination)
    dest_x = destination[0] * 160
    dest_y = destination[1] * 160

    complete_x = false
    complete_y = false

    if self.x - dest_x < 0
      self.x += 1
    elsif self.x == dest_x
      complete_x = true
    else
      self.x -= 1
    end

    if self.y - dest_y < 0
      self.y += 1
    elsif self.y == dest_y
      complete_y = true
    else
      self.y -= 1
    end

    if [complete_x, complete_y] == [true, true]
    	return false
    else
    	return true
    end

  end

  private
  def adjust_angle
    self.angle += 360
    self.angle %= 360
  end
end