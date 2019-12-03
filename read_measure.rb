# for making statistics of reading
class Info

  attr_accessor :start, :end, :page_started, :page_ended

  def finish
    @end = Time.now
  end

  def measure
    puts 'Page you started reading: '
    @page_started = gets.chomp
    puts 'Are you ready to start? y/n'
    status = gets.chomp
    while status != 'y'
      puts 'Are you ready to start? y/n'
      status = gets.chomp
    end
    @start = Time.now
    status = 'n'
    while status != 'y'
      puts 'Have you finished? y/n'
      status = gets.chomp
    end
    @end = Time.now
    puts 'Page you finished: '
    @page_ended = gets.chomp
    calculations
  end

  def sec_to_min(seconds)
    if (seconds / 60) / 60 >= 1
      hour = (seconds.to_i / 60) / 60
      min =  (seconds.to_i - (hour * 60 * 60)) / 60
      sec = seconds - ((hour * 60 * 60) + (min * 60))
      "#{hour} hours #{min} minutes #{sec.round(1)} seconds"
    else
      min = seconds.to_i / 60
      sec = seconds - min * 60
      "#{min} minutes #{sec.round(1)} seconds"
    end
  end

  def total_sec
    @end.to_i - @start.to_i
  end

  def page_read
    (@page_ended.to_f - @page_started.to_f) + 1
  end

  def calculations
    puts "Time you started reading: #{@start.strftime('%Y-%m-%d %H:%M:%S')}"
    puts "Time you finished reading: #{@end.strftime('%Y-%m-%d %H:%M:%S')}"
    puts "Page you started reading: #{@page_started}"
    puts "Page you finished reading: #{@page_ended}"
    puts "You was reading for: #{sec_to_min(total_sec)}"
    puts "You read: #{page_read} pages"
    puts "Average time to read 1 page: #{sec_to_min(total_sec / page_read.to_f)}"
  end
end

Info.new.measure
