#First fetch all of the possible stations
stations = Station.find(:all)

#Then lets traverse each station and build the appropriate menus to  be Adhearsion contexts
stations.each do |station|
  station.menus(:order => "playback_order").each do |my_menu|
    eval <<-CONTEXT
      #{my_menu.name} { 
        menu my_menu.audio_file, :timeout => station.timeout.seconds, :tries =>station.tries  do |link|
          options = my_menu.options
          for option in options
            puts option.name + option.option_number.to_s
            link.send('set_avatar_attribute', option.option_number)
          end
          link.on_invalid { play 'invalid' }
          link.on_premature_timeout do |str|
            play 'sorry'
          end
          link.on_failure do
            play 'goodbye'
            hangup
          end
        end
      }
     CONTEXT
  end
end

twinners_test {
  @avatar_attributes = String.new
  @cnt = 0
  @menus = Station.find_by_name(context).menus
  @number_of_menus = @menus.length
  +build_avatar
}

build_avatar {
  @cnt += 1
  if @cnt <= @number_of_menus
    puts @menus[@cnt-1].name
    +eval(@menus[@cnt-1].name)
  else
    puts "Attributes: " + @avatar_attributes
    play 'goodbye'
    hangup
  end
}

set_avatar_attribute {
  @avatar_attributes = @avatar_attributes + extension.to_s
  puts "Building: " + @avatar_attributes
  +build_avatar
}