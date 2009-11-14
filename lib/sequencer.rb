class Sequencer
  attr_reader :col
  def initialize
    @grid = []
    8.times { |col| @grid[col] = [] ; 8.times { |row| @grid[col][row] = 0 } }
    @col = 0
  end
  
  def prev
    (@col - 1) < 0 ? 7 : @col - 1
  end
    
  def col
    @col || 0
  end

  def [](x,y)
    @grid[x][y]
  end
  
  def []=(x,y,v)
    @grid[x][y] = v
  end
  
  def advance
    @col = (@col + 1) % 8
  end
  
  def self.pentatonic(note)
    [0,2,4,7,9][(note %5)]+ (12 * (note/5).to_i)
  end
  
end
