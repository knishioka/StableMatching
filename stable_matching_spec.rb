load 'stable_matching.rb'

describe GaleShapleyMatching, "GS-algorithm" do
  it "returns stable matching" do
    100.times do
      group_size = rand(10..100)
      user_preferences = Array.new(group_size){ Array.new(group_size){ |i| i }.shuffle }
      target_user_preferences = Array.new(group_size){ Array.new(group_size){ |i| i }.shuffle }.shuffle
      phash = Hash.new
      user_preferences.each_with_index do |list, target_user_id|
        phash[target_user_id] = Hash.new
        list.each_with_index do |user_id, order|
          phash[target_user_id][user_id] = order
        end
      end
      target_phash = Hash.new
      target_user_preferences.each_with_index do |list, target_user_id|
        target_phash[target_user_id] = Hash.new
        list.each_with_index do |user_id, order|
          target_phash[target_user_id][user_id] = order
        end
      end
      gs = GaleShapleyMatching.new(user_preferences, target_user_preferences)
      pairs = gs.matching
      for j in 0..group_size-1
        for i in j+1..group_size-1
          m = pairs[j][0];  w = pairs[j][1]
          m2 = pairs[i][0]; w2 = pairs[i][1]
          (phash[m][w2] < phash[m][w] and
           phash[m2][w] > phash[m2][w2] and
           target_phash[w][m2] < target_phash[w][m] and
           target_phash[w2][m2] > target_phash[w2][m]).should == false
        end
      end
    end
  end
end
