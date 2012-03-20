class GaleShapleyMatching
  def initialize(preference_list, target_preference_list)
    @plist = preference_list
    @phash = Hash.new
    preference_list.each_with_index do |list, target_user_id|
      @phash[target_user_id] = Hash.new
      list.each_with_index do |user_id, order|
        @phash[target_user_id][user_id] = order
      end
    end
    @target_phash = Hash.new
    target_preference_list.each_with_index do |list, target_user_id|
      @target_phash[target_user_id] = Hash.new
      list.each_with_index do |user_id, order|
        @target_phash[target_user_id][user_id] = order
      end
    end
      
    @unmatched_users = Array.new(@plist.size){ |i| i }
    @target_user_partner = Array.new(@plist.size){ nil }
    @next_propose_index = Array.new(@plist.size){ 0 }
  end

  # return two dimension array of matched users
  def matching
    while !@unmatched_users.empty? do
      unmatched_user = @unmatched_users.shift
      target_user = @plist[unmatched_user][@next_propose_index[unmatched_user]]
      @next_propose_index[unmatched_user] += 1
      if @target_user_partner[target_user]
        if @target_phash[target_user][@target_user_partner[target_user]] < @target_phash[target_user][unmatched_user]
          @unmatched_users.push unmatched_user
        else
          @unmatched_users.push @target_user_partner[target_user]
          @target_user_partner[target_user] = unmatched_user
        end
      else
        @target_user_partner[target_user] = unmatched_user
      end
    end
    @target_user_partner.map.with_index{ |e, i| [e, i] }
  end
end
