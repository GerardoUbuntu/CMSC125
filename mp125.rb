module Simulator
    class Processo       
        attr_accessor :number, :color, :arrival_time, :allocres, :maxres, :cylinders , :priority_no, :cputime, :waiting_time, :response_time, :turn_around
        def initialize(number, color, arrival_time, allocres, maxres, cylinders, priority_no = -1)
            @number = number
            @color = color
            @priority_no = priority_no
            @arrival_time = arrival_time
            @allocres = allocres
            @maxres = maxres
            @cylinders = cylinders
            @priority_no = priority_no
        end 

        def remove
            @cputime = @maxres.shift.to_i
            @allocres.shift
        end
    end

    class Simulation
       attr_accessor :cpusim, :disksim, :no, :quanta 
       def initialize(cpualgo, diskalgo, no, quanta)
           @cpusim = cpualgo
           @disksim = diskalgo
           @no = no
           @quanta = quanta
       end
    end
end
Shoes.app(:title => "CPU and Disk Simulator",
   :width => 1366, :height => 768, :resizable => false) do extend Simulator 
    background white
    def algo(no)
        puts "hahaha"
        stack(:width=> 400, :margin=> 30, :height => 200)  do 
            cpusched = ["FCFS", "SJF", "SRTF", "Priority  Sched", "Preemptive-Priority Sched", "Round Robin"]
            bank =   ["TDDT", "TDTD(continuous)", "TDTD(reset)"]
            disk =   ["FCFS", "SSTF", "C-SCAN", "SCAN", "LOOK", "CLOOK"]    
            background gainsboro
            para "Simulation #{no}"
            flow{ 
                para "CPU ALGORITHM"
                @algolist[no-1] = list_box :items => cpusched ,
                :width => 100, :choose => cpusched[no-1] do |list|
                    @cpualgo.text = list.text
                  
                end
            } 
            @algolist[no-1].margin_left = 90
            @cpualgos[no-1]= cpusched[no-1]
             quanta = flow{}
             @algolist[no-1].change(){
                   @cpualgos[no-1] = @algolist[no-1].text 
                  if(@algolist[no-1].text ==  "Round Robin")
                        quanta.clear(){
                            para "Quantum Time"
                            edit = edit_line :margin_left=> 10 do |e|
                               @quantumTimes[no-1] = e.text.sub( /\D/, '').to_i
                           end
                           edit.text = 1
                           @quantumTimes[no-1] = 1
                        }
                   else
                       quanta.clear(){}
                   end 
                }
            flow{ 
                para "DISK'S ALGORITHM"
                @disklist[no-1] = list_box :items => disk,
                :width => 100, :choose => disk[0] do |list|
                    @diskalgo.text = list.text
                end
            }  
            
            @disklist[no-1].margin_left =74  
            @diskAlgos[no-1] = disk[0]
            @disklist[no-1].change(){
                @diskAlgos[no-1] = @disklist[no-1].text
            }
        end
    end

    def displayStat(processes, cypass = [])
        stack :height=> 235, :width=> 300, :top=> 0, :scroll=> true  do
            background white
            para "                        Statistics"
            processes = processes.sort_by!{|obj| obj.number}
            dims = [70, 70,70, 70] 
            waiting=0
            responce =0
            turn_around = 0
            label = ["Process", "Waiting Time", "Response Time", "Turn Around Time"]
            left = 0
            add = 0 
            top = 60
            flow do
            for x in 0..label.length-1
                fill aqua
                rect left, 10, dims[x], 50
                if ( x > 2 ) 
                    add = 10
                end
                a = flow :left=> left + add , :top => 15, :width=> dims[x], :height=> 40  do
                    
                end
                a.append(){
                    inscription label[x]
                }
                left+= dims[x]
            end 
        end
            a = flow do end
            para <<-'END'
  






          
                    




















  





















































            


            END
            for x in 0..processes.length-1
                values = [processes[x].number.to_s, processes[x].waiting_time.to_s, processes[x].response_time.to_s, processes[x].turn_around.to_s]
                waiting += processes[x].waiting_time
                responce += processes[x].response_time
                turn_around += processes[x].turn_around
                left = 0
                add = 0
                a.append(){
                    flow do
                        for y in 0..3
                            fill processes[x].color
                            rect left, top, dims[y], 20
                            
                            if ( y > 2 ) 
                                add = 10
                            end

                            para "   ", :left=> left + add , :top => top+2  
                            b = flow :left=> left + add , :top => top+2, :width=> dims[y], :height=> 20  do
                            end
                            b.append(){
                                inscription values[y], :weight=> "semibold"
                            }
                            left+= dims[y]
                        end
                    end
                }
                top+=20
            end


            a.append(){
                flow {
                  stack do
                    a = cypass.each_slice(10).to_a
                    b = @cylinders.each_slice(10).to_a
                    top += 42
                    inscription "Cylinders: " , :left=> 0 , :top => top, :weight=> "semibold", :emphasis => "italic"
                    top += 20
                    for i in b 
                        inscription " #{i.join(',')}" , :left=> 0 , :top => top, :weight=> "semibold", :emphasis => "italic"
                        top += 20      
                    end
                    top += 30
                    inscription "Order of Cylinders: " , :left=> 0 , :top => top, :weight=> "semibold", :emphasis => "italic"
                    top +=20
                    for i in a 
                        inscription " #{i.join(',')}" , :left=> 0 , :top => top, :weight=> "semibold", :emphasis => "italic"
                        top += 20      
                    end
                    inscription "Average Waiting Time: #{waiting/processes.length}" , :left=> 0 , :top => top+22, :weight=> "semibold", :emphasis => "italic"
                    inscription "Average Responce Time: #{responce/processes.length}" , :left=> 0 , :top => top+42, :weight=> "semibold",  :emphasis => "italic"
                    inscription "Average Turn Around Time: #{turn_around/processes.length}", :left=> 0 , :top => top+62, :weight=> "semibold", :emphasis => "italic"
                    
                    seektime = 0
                    for i in 0..cypass.length-2
                        seektime += (cypass[i+1] - cypass[i]).abs 
                    end
                    inscription "Total Seek Time: #{seektime}", :left=> 0 , :top => top+82, :weight=> "semibold", :emphasis => "italic"

                  end
                }
            }       
        end
    end
    
    def FCFS(processArr, x, y, w=473, h, diskalgo, no, cylinders, diskUsed)
          @coco.append(){
           puts processArr.length
           ready = []
           job = [] 
           currProcess = -1
           cypass = cylinders.dup
           processArr = processArr.map!{|a| a.dup}
           processArr = processArr.each do |a| a.cylinders = a.cylinders.dup end
           processArr.sort_by!{|obj| obj.arrival_time}
           processArr.each{|a| puts a.arrival_time}
           vectors = @vectors.dup
           vectors.shift
           processes = processArr.dup
           available = vectors.map{|a| a.text.to_i}
           puts "available: #{available}"
           x1 = 2
           curColor = nil 
           cyVal = [@headCy.text.to_i,@headCy.text.to_i]
           puts "#{cyVal}"
           x_axis2 = ["0", "0"]
            chart =  flow :top => y + 100, :left => x do 
                    
                    plot_area = stack do
                        @plots[no] = plot 320, 300, title: diskUsed, caption: "X:Time Y: Sector",
                            font: "Helvetica", auto_grid: true, default: "skip", background: white
                        
                        @cs[no] = chart_series values: cyVal, labels: x_axis2, name: "foobar", 
                            min: 0, max: @maxCy.text.to_i+5 , desc: "Sectors Movement", color: rgb(rand(255),rand(255), rand(555)),
                            points: true   
                        @plots[no].add @cs[no]   
                    end
                    @stats[no] = flow :left=>500, :top=> 0 do end
            end
             puts "#{available}"    
           stack :left=> x, :top=> y, :height=> 400, :scroll=>true do 
                para "Simulation #{no} FCFS", :align=>"center" , :weight=> "semibold", :emphasis => "italic"
                border black, :strokewidth => 2  
                count = 0
                slot = flow :top=>0 do end
                flow :top=> 80, :left=> 0 do
                    back_button = image "back.png"
                    back_button.click{
                        puts "#{slot.width}"                                                                                                                                                                
                        slot.move slot.left - 10 , slot.top
                    }
                    forward_button = image "forward.png", :margin_left=>870
                    forward_button.click{
                        if(slot.left != 0)
                           slot.move slot.left + 10 , slot.top
                        end
                    }
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               end
                slot.clear{}
                puts processArr.empty? && job.empty? && ready.empty?
               @everies[no] = every @speed do
                
                    if(x1 > w) 
                        slot.move slot.left - 10 , slot.top
                    end
                    if(processArr.empty? && job.empty? && ready.empty? && cylinders.length ==1)
                        @everies[no].stop
                        slot.append(){
                            stack :left=> x1-5, :top =>55, :width=>30, :height=> 20  do
                                inscription count
                            end
                            
                        } 
                        @stats[no].clear(){
                            displayStat(processes,cypass)
                        }
                    elsif(processArr.empty? && !job.empty? && ready.empty?)
                        @everies[no].stop
                        slot.append(){
                            stack :left=> x1-5, :top =>55, :width=>30, :height=> 20  do
                                inscription count
                            end
                            
                        } 
                        alert("Deadlock", :title => nil)
                    else
                        puts processArr.empty? && job.empty? && ready.empty?
                        if(!processArr.empty?)
                            job+=processArr.select { |favor| favor.arrival_time == count }
                            processArr.select! { |favor| favor.arrival_time != count }
                        end
                        if(!job.empty?)
                        
                        len = job.length-1
                        puts len
                        for x in 0..len
                            puts "satisfy"
                            need = [job[x].maxres,job[x].allocres].transpose.map{|x| x.reduce(:-)}                       
                            satisfy = available.zip(need).map { |x, y| x >= y }.include?(false) # [true, false, true]  
                            puts "process#{job[x].number} need: #{need}"
                            if(!satisfy)
                                puts "pinasok"
                                available = [available,need].transpose.map{|x| x.reduce(:-)} 
                                ready.push(job[x])
                                job[x] = nil
                            end
                        end
                        job.compact!
                        end
                        if(!ready.empty?)
                            puts "not"
                        
                            slot.append{
                                process = ready[0]

                                if ready[0].waiting_time.nil?
                                    ready[0].response_time = count 
                                end 

                                if(currProcess != ready[0].number || ready[0].waiting_time.nil?)
                                     ready[0].waiting_time = count - ready[0].arrival_time     
                                end
                                currProcess = ready[0].number
                                stroke process.color
                                fill process.color
                                rect x1, 20, 20, 30
                                
                                if(curColor != process.color)
                                    stack :left=> x1-5, :top =>55, :width=>30, :height=> 20  do
                                        inscription count
                                    end 
                                    curColor = process.color
                                end
                                x1+=20
                                count+=1
                                ready[0].cputime -= 1
                                stack :top => 200, :left => 0 do 
                                    
                                        puts "cylinders #{ready[0].cylinders.length}"
                                        cyVal << cylinders[0]
                                        if(cylinders.length > 1)
                                            cylinders.shift
                                        end
                                        x_axis2 << count.to_s 
                                    puts process.color
                                    @cs[no].color = process.color
                                    @plots[no].redraw_to(cyVal.length)
                                    
                                    
                                 end
                                 
                        
                            if(ready[0].cputime <= 0)
                                ready[0].turn_around = count - ready[0].arrival_time 
                                puts "available: #{available}"
                                available = [available,ready[0].maxres].transpose.map{|x| x.reduce(:+)}
                                ready.shift
                                
                            end 
                            
                            }
                        
                        
                            
                        elsif(job.empty? || ready.empty?)
                        slot.append{
                            stroke rgb(128,128,128)
                            fill rgb(128,128,128)   
                            rect x1, 20, 20, 30
                        
                        

                            if(curColor != rgb(128,128,128))
                                stack :left=> x1-5, :top =>55, :width=>30, :height=> 20  do
                                    inscription count
                                end 
                                curColor = rgb(128,128,128)
                            end
                            x1+=20
                            count+=1
                           
                        }    
                        end
                    
                    end
                end 
           end

               
             
        
        }
    end

    def SJF(processArr, x, y, w=473, h, diskalgo, no, cylinders, diskUsed)
         @coco.append(){
           puts processArr.length
           ready = []
           job = [] 
           currProcess = -1
           done = true
           cypass = cylinders.dup
           processArr = processArr.map!{|a| a.dup}
           processArr = processArr.each do |a| a.cylinders = a.cylinders.dup end
           processArr.sort_by!{|obj| obj.arrival_time}
           processArr.each{|a| puts a.arrival_time}
           vectors = @vectors.dup
           vectors.shift
           processes = processArr.dup
           available = vectors.map{|a| a.text.to_i}
          
           x1 = 2
           curColor = nil 
           cyVal = [@headCy.text.to_i,@headCy.text.to_i]
           puts "#{cyVal}"
           x_axis2 = ["0", "0"]
           
           chart =  stack :top => y + 100, :left => x do 
                
                plot_area = stack do
                    @plots["SJF"] = plot 320, 300, title: diskUsed, caption: "X:Time Y: Sector",
                            font: "Helvetica", auto_grid: true, default: "skip", background: white
                    @cs["SJF"] = chart_series values: cyVal, labels: x_axis2, name: "foobar", 
                        min: 0, max: @maxCy.text.to_i+5 , desc: "Sectors Movement", color: rgb(rand(255),rand(255), rand(555)),
                        points: true
                    @plots["SJF"].add @cs["SJF"]   
                end
                @stats["SJF"] = flow :left=>500, :top=> 0 do end
           end
       
             puts "#{available}"    
           stack :left=> x, :top=> y do 
                para "Simulation #{no} SJF", :align=>"center", :weight=> "semibold", :emphasis => "italic"
                border black, :strokewidth => 2    
                count = 0
                slot = flow :top=>0 do end
                flow :top=> 80, :left=> 0 do
                    back_button = image "back.png"
                    back_button.click{
                        puts "#{slot.width}"
                        slot.move slot.left - 10 , slot.top
                    }
                    forward_button = image "forward.png", :margin_left=>870
                    forward_button.click{
                        if(slot.left !=0)
                        slot.move slot.left + 10 , slot.top
                        end
                    }
                end
                slot.clear{}
                puts processArr.empty? && job.empty? && ready.empty?
               @everies["SJF"] = every @speed do
                    if(x1 > w) 
                        slot.move slot.left - 10 , 0 
                    end
                    if(processArr.empty? && job.empty? && ready.empty?)
                        @everies["SJF"].stop
                        slot.append(){
                            stack :left=> x1-5, :top =>55, :width=>20, :height=> 20  do
                                inscription count
                            end
                        } 
                        @stats["SJF"].clear(){
                            displayStat(processes,cypass)
                        }
                        
                    elsif(processArr.empty? && !job.empty? && ready.empty?)
                        @everies["SJF"].stop
                        slot.append(){
                            stack :left=> x1-5, :top =>55, :width=>30, :height=> 20  do
                                inscription count
                            end
                            
                        } 
                        alert("Deadlock", :title => nil)    
                    else
                        puts processArr.empty? && job.empty? && ready.empty?
                        if(!processArr.empty?)
                            job+=processArr.select { |favor| favor.arrival_time == count }
                            processArr.select! { |favor| favor.arrival_time != count }
                        end
                        if(!job.empty?)
                        
                        len = job.length-1
                        puts len
                        for x in 0..len
                                puts "satisfy"
                            need = [job[x].maxres,job[x].allocres].transpose.map{|x| x.reduce(:-)}                       
                            satisfy = available.zip(need).map { |x, y| x >= y }.include?(false) # [true, false, true]  
                            if(!satisfy)
                                puts "pinasok"
                                available = [available,need].transpose.map{|x| x.reduce(:-)} 
                                ready.push(job[x])
                                job[x] = nil
                            end
                        end
                        job.compact!
                        end
                        if(!ready.empty?)
                            puts "not"
                        
                            slot.append{
                                if(done == true)
                                   ready.sort_by!{|obj| obj.cputime}
                                   done = false
                                end 
                                
                                if ready[0].waiting_time.nil?
                                    ready[0].response_time = count 
                                end 

                                if(currProcess != ready[0].number || ready[0].waiting_time.nil?)
                                     ready[0].waiting_time = count - ready[0].arrival_time    
                                end
                                currProcess = ready[0].number

                                process = ready[0]
                                stroke process.color
                                fill process.color
                                rect x1, 20, 20, 30
                                
                                if(curColor != process.color)
                                    stack :left=> x1-5, :top =>55, :width=>20, :height=> 20  do
                                        inscription count
                                    end 
                                    curColor = process.color
                                end
                                x1+=20
                                count+=1
                                ready[0].cputime -= 1
                                stack :top => 200, :left => 0 do 
                                    
                                        
                                        cyVal << cylinders[0]
                                        if(cylinders.length > 1)
                                            cylinders.shift
                                        end
                                        x_axis2 << count.to_s 
                                    
                                
                                    ready[0].cylinders.shift
                                    @cs["SJF"].color = process.color
                                    @plots["SJF"].redraw_to(cyVal.length)
                            end
                        
                            if(ready[0].cputime <= 0)
                                ready[0].turn_around = count - ready[0].arrival_time
                                available = [available,ready[0].maxres].transpose.map{|x| x.reduce(:+)}
                                ready.shift
                                done = true
                            end 
                            
                        }
                        
                        
                            
                        elsif(job.empty? || ready.empty?)
                        slot.append{
                            stroke rgb(128,128,128)
                            fill rgb(128,128,128)   
                            rect x1, 20, 20, 30
                        
                        

                            if(curColor != rgb(128,128,128))
                                stack :left=> x1-5, :top =>55, :width=>30, :height=> 20  do
                                    inscription count
                                end 
                                curColor = rgb(128,128,128)
                            end
                            x1+=20
                            count+=1
                          
                        }    
                        end
                    
                 
                    end
                end 
           end

               
             
        
        }
    end

    def SRTF(processArr, x, y, w=473, h, diskalgo, no, cylinders, diskUsed)
         @coco.append(){
           currProcess = -1
           ready = []
           job = [] 
           cypass = cylinders.dup
           processArr = processArr.map!{|a| a.dup}
           processArr = processArr.each do |a| a.cylinders = a.cylinders.dup end
           processArr.sort_by!{|obj| obj.arrival_time}
           processArr.each{|a| puts a.arrival_time}
           vectors = @vectors.dup
           vectors.shift
           processes = processArr.dup
           available = vectors.map{|a| a.text.to_i}
          
           x1 = 2
           curColor = nil 
           cyVal = [@headCy.text.to_i,@headCy.text.to_i]
           puts "#{cyVal}"
           x_axis2 = ["0", "0"]
           chart =  stack :top => y + 100, :left => x do 
                
                plot_area = stack do
                    @plots[no] = plot 320, 300, title: diskUsed, caption: "X:Time Y: Sector",
                            font: "Helvetica", auto_grid: true, default: "skip", background: white
                   @cs[no] = chart_series values: cyVal, labels: x_axis2, name: "foobar", 
                        min: 0, max: @maxCy.text.to_i+5 , desc: "Sectors Movement", color: rgb(rand(255),rand(255), rand(555)),
                        points: true
                    @plots[no].add @cs[no]     
                end
                @stats[no] = flow :left=>500, :top=> 0 do end
           end
    
           puts "#{available}"    
           stack :left=> x, :top=> y do 
                para "Simulation #{no} SRTF", :align=>"center", :weight=> "semibold", :emphasis => "italic"
                border black, :strokewidth => 2    
                count = 0
                 slot = flow :top=>0 do end
                flow :top=> 80, :left=> 0 do
                    back_button = image "back.png"
                    back_button.click{
                        puts "#{slot.width}"
                        slot.move slot.left - 10 , slot.top
                    }
                    forward_button = image "forward.png", :margin_left=>870
                    forward_button.click{
                        if(slot.left !=0)
                        slot.move slot.left + 10 , slot.top
                        end
                    }
                end
                slot.clear{} 
                puts processArr.empty? && job.empty? && ready.empty?
               @everies[no] = every @speed do
                    puts "x1: #{x1}"
                    if(x1 > w) 
                        slot.move slot.left - 10 , 0 
                    end
                    if(processArr.empty? && job.empty? && ready.empty?)
                        @everies[no].stop
                        slot.append(){
                            stack :left=> x1-5, :top =>55, :width=>20, :height=> 20  do
                                inscription count
                            end
                        } 
                         
                        @stats[no].clear(){
                            displayStat(processes, cypass)
                        }
                    elsif(processArr.empty? && !job.empty? && ready.empty?)
                        @everies[no].stop
                        slot.append(){
                            stack :left=> x1-5, :top =>55, :width=>30, :height=> 20  do
                                inscription count
                            end
                            
                        } 
                        alert("Deadlock", :title => nil)  
                    else
                        puts processArr.empty? && job.empty? && ready.empty?
                        if(!processArr.empty?)
                            job+=processArr.select { |favor| favor.arrival_time == count }
                            processArr.select! { |favor| favor.arrival_time != count }
                        end
                        if(!job.empty?)
                        
                        len = job.length-1
                        puts len
                        for x in 0..len
                               
                            need = [job[x].maxres,job[x].allocres].transpose.map{|x| x.reduce(:-)}                       
                            satisfy = available.zip(need).map { |x, y| x >= y }.include?(false) # [true, false, true]  
                            if(!satisfy)
                                available = [available,need].transpose.map{|x| x.reduce(:-)}  
                                ready.push(job[x])
                                job[x] = nil
                            end
                        end
                        job.compact!
                        end
                        if(!ready.empty?)
                            puts "not"
                        
                            slot.append{
                                ready.sort_by!{|obj| obj.cputime}
                                process = ready[0]

                                if ready[0].waiting_time.nil?
                                    ready[0].response_time = count 
                                end 

                                if(currProcess != ready[0].number || ready[0].waiting_time.nil?)
                                     ready[0].waiting_time =  ready[0].waiting_time.to_i + (count - ready[0].arrival_time)     
                                end
                                 currProcess = ready[0].number
                                stroke process.color
                                fill process.color
                                rect x1, 20, 20, 30
                                
                                if(curColor != process.color)
                                    stack :left=> x1-5, :top =>55, :width=>30, :height=> 20  do
                                        inscription count
                                    end 
                                    curColor = process.color
                                end
                                x1+=20
                                count+=1
                                ready[0].cputime -= 1
                           
                                stack :top => 200, :left => 0 do 
                                    
                                        
                                        cyVal << cylinders[0]
                                        if(cylinders.length > 1)
                                            cylinders.shift
                                        end
                                        x_axis2 << count.to_s 
                                    
                                
                                    ready[0].cylinders.shift
                                    @cs[no].color = process.color
                                    @plots[no].redraw_to(cyVal.length)
                            end
                        
                            if(ready[0].cputime <= 0)
                                ready[0].turn_around = count - ready[0].arrival_time
                                ready[0].arrival_time = count
                                available = [available,ready[0].maxres].transpose.map{|x| x.reduce(:+)}
                                ready.shift
                            end 
                           
                            }
                        
                        
                            
                        elsif(job.empty? || ready.empty?)
                        slot.append{
                            stroke rgb(128,128,128)
                            fill rgb(128,128,128)   
                            rect x1, 20, 20, 30
                        
                        

                            if(curColor != rgb(128,128,128))
                                stack :left=> x1-5, :top =>55, :width=>30, :height=> 20  do
                                    inscription count
                                end 
                                curColor = rgb(128,128,128)
                            end
                            x1+=20
                            count+=1
                          
                        }    
                        end
                    end
                end 
           end

               
             
        
        }
    end
    
    def PRIO(processArr, x, y, w=473, h, diskalgo, no, cylinders, diskUsed)
         @coco.append(){
           puts processArr.length
           ready = []
           job = [] 
           cypass = cylinders.dup
           currProcess = -1
           processArr = processArr.map!{|a| a.dup}
           processArr = processArr.each do |a| a.cylinders = a.cylinders.dup end
           processArr.sort_by!{|obj| obj.arrival_time}
           processArr.each{|a| puts a.arrival_time}
           vectors = @vectors.dup
           vectors.shift 
           processes = processArr.dup
           available = vectors.map{|a| a.text.to_i}
           x1 = 2
           curColor = nil 
           cyVal = [@headCy.text.to_i,@headCy.text.to_i]
           puts "#{cyVal}"
           x_axis2 = ["0", "0"]
           chart =  stack :top => y + 100, :left => x do 
                
                plot_area = stack do
                    @plots[no] = plot 320, 300, title: diskUsed, caption: "X:Time Y: Sector",
                        font: "Helvetica", auto_grid: true, default: "skip", background: white
                    @cs[no] = chart_series values: cyVal, labels: x_axis2, name: "foobar", 
                        min: 0, max: @maxCy.text.to_i+5 , desc: "Sectors Movement", color: rgb(rand(255),rand(255), rand(555)),
                        points: true 
                    @plots[no].add @cs[no]    
                end
                 @stats[no] = flow :left=>500, :top=> 0 do end
           end
       
           stack :left=> x, :top=> y do 
                para "Simulation #{no} Preemptive-Priority Sched", :align=>"center", :weight=> "semibold", :emphasis => "italic"
                border black, :strokewidth => 2    
                count = 0
                 slot = flow :top=>0 do end
                flow :top=> 80, :left=> 0 do
                    back_button = image "back.png"
                    back_button.click{
                        puts "#{slot.width}"
                        slot.move slot.left - 10 , slot.top
                    }
                    forward_button = image "forward.png", :margin_left=>870
                    forward_button.click{
                        if(slot.left !=0)
                        slot.move slot.left + 10 , slot.top
                        end
                    }
                end
                slot.clear{}
                puts processArr.empty? && job.empty? && ready.empty?
               @everies[no] = every @speed do
                    puts "x1: #{x1}"
                    if(x1 > w) 
                        slot.move slot.left - 10 , 0 
                    end
                    if(processArr.empty? && job.empty? && ready.empty?)
                        @everies[no].stop
                        slot.append(){
                            stack :left=> x1-5, :top =>55, :width=>20, :height=> 20  do
                                inscription count
                            end
                        } 
                         @stats[no].clear(){
                            displayStat(processes, cypass)
                        }
                        
                    elsif(processArr.empty? && !job.empty? && ready.empty?)
                        @everies[no].stop
                        slot.append(){
                            stack :left=> x1-5, :top =>55, :width=>30, :height=> 20  do
                                inscription count
                            end
                            
                        } 
                        alert("Deadlock", :title => nil)

                    else
                        puts processArr.empty? && job.empty? && ready.empty?
                        if(!processArr.empty?)
                            job+=processArr.select { |favor| favor.arrival_time == count }
                            processArr.select! { |favor| favor.arrival_time != count }
                        end
                        if(!job.empty?)
                        
                        len = job.length-1
                        puts len
                        for x in 0..len
                                puts "satisfy"
                            need = [job[x].maxres,job[x].allocres].transpose.map{|x| x.reduce(:-)}                       
                            satisfy = available.zip(need).map { |x, y| x >= y }.include?(false) # [true, false, true]  
                            if(!satisfy)
                                puts "pinasok"
                                available = [available,need].transpose.map{|x| x.reduce(:-)} 
                                ready.push(job[x])
                                job[x] = nil
                            end
                        end
                        job.compact!
                        end
                        if(!ready.empty?)
                            puts "not"
                        
                            slot.append{
                                ready.sort_by!{|obj| obj.priority_no}
                                process = ready[0]
                                if ready[0].waiting_time.nil?
                                    ready[0].response_time = count 
                                end 

                                if(currProcess != ready[0].number || ready[0].waiting_time.nil?)
                                     ready[0].waiting_time =  ready[0].waiting_time.to_i + (count - ready[0].arrival_time)     
                                end
                                 currProcess = ready[0].number
                                stroke process.color
                                fill process.color
                                rect x1, 20, 20, 30
                                
                                if(curColor != process.color)
                                    stack :left=> x1-5, :top =>55, :width=>30, :height=> 20  do
                                        inscription count
                                    end 
                                    curColor = process.color
                                end
                                x1+=20
                                count+=1
                                ready[0].cputime -= 1
                            puts ready[0].cputime
                                stack :top => 200, :left => 0 do 
                                    
                                        
                                        cyVal << cylinders[0]
                                        if(cylinders.length > 1)
                                            cylinders.shift
                                        end
                                        x_axis2 << count.to_s 
                                    
                                
                                    ready[0].cylinders.shift
                                    @cs[no].color = process.color
                                    @plots[no].redraw_to(cyVal.length)
                            end
                        
                            if(ready[0].cputime <= 0)
                                ready[0].turn_around = count - ready[0].arrival_time
                                ready[0].arrival_time = count
                                available = [available,ready[0].maxres].transpose.map{|x| x.reduce(:+)}
                                ready.shift
                            end 
                            }
                        
                        
                            
                        elsif(job.empty? || ready.empty?)
                        slot.append{
                            stroke rgb(128,128,128)
                            fill rgb(128,128,128)   
                            rect x1, 20, 20, 30
                        
                        

                            if(curColor != rgb(128,128,128))
                                stack :left=> x1-5, :top =>55, :width=>30, :height=> 20  do
                                    inscription count
                                end 
                                curColor = rgb(128,128,128)
                            end
                            x1+=20
                            count+=1
                          
                        }    
                        end
                    
                    puts "huhuhu"
                    end
                end 
           end

               
             
        
        }
    end

    def NPPRIO(processArr, x, y, w=473, h, diskalgo, no, cylinders, diskUsed)
         @coco.append(){
           puts processArr.length
           ready = []
           job = [] 
           done = true
           currProcess = -1
           cypass = cylinders.dup
           processArr = processArr.map!{|a| a.dup}
           processArr = processArr.each do |a| a.cylinders = a.cylinders.dup end
           processArr.sort_by!{|obj| obj.arrival_time}
           processArr.each{|a| puts a.arrival_time}
           vectors = @vectors.dup
           vectors.shift
           processes = processArr.dup
           available = vectors.map{|a| a.text.to_i}
           x1 = 2
           curColor = nil 
           cyVal = [@headCy.text.to_i,@headCy.text.to_i]
           puts "#{cyVal}"
           x_axis2 = ["0", "0"]
           chart =  stack :top => y + 100, :left => x do 
                
                plot_area = stack do
                    @plots[no] = plot 320, 300, title: diskUsed, caption: "X:Time Y: Sector",
                            font: "Helvetica", auto_grid: true, default: "skip", background: white
                    @cs[no] = chart_series values: cyVal, labels: x_axis2, name: "foobar", 
                        min: 0, max: @maxCy.text.to_i+5 , desc: "Sectors Movement", color: rgb(rand(255),rand(255), rand(555)),
                        points: true   
                    @plots[no].add @cs[no]
                end
                @stats[no] = flow :left=>500, :top=> 0 do end
           end
             puts "#{available}"    
           stack :left=> x, :top=> y do 
                para "Simulation #{no} Priority Sched", :align=>"center", :weight=> "semibold", :emphasis => "italic"
                border black, :strokewidth => 2    
                count = 0
                slot = flow :top=>0 do end
                flow :top=> 80, :left=> 0 do
                    back_button = image "back.png"
                    back_button.click{
                        puts "#{slot.width}"
                        slot.move slot.left - 10 , slot.top
                    }
                    forward_button = image "forward.png", :margin_left=>870
                    forward_button.click{
                        if(slot.left !=0)
                        slot.move slot.left + 10 , slot.top
                        end
                    }
                end
                slot.clear{}
                puts processArr.empty? && job.empty? && ready.empty?
               @everies[no] = every @speed do
                    puts "x1: #{x1}"
                    if(x1 > w) 
                        slot.move slot.left - 10 , 0 
                    end
                    if(processArr.empty? && job.empty? && ready.empty?)
                        @everies[no].stop
                        slot.append(){
                            stack :left=> x1-5, :top =>55, :width=>20, :height=> 20  do
                                inscription count
                            end
                        } 
                         @stats[no].clear(){
                            displayStat(processes, cypass)
                        }
                    
                    elsif(processArr.empty? && !job.empty? && ready.empty?)
                        @everies[no].stop
                        slot.append(){
                            stack :left=> x1-5, :top =>55, :width=>30, :height=> 20  do
                                inscription count
                            end
                            
                        } 
                        alert("Deadlock", :title => nil)
                    else
                        puts processArr.empty? && job.empty? && ready.empty?
                        if(!processArr.empty?)
                            job+=processArr.select { |favor| favor.arrival_time == count }
                            processArr.select! { |favor| favor.arrival_time != count }
                        end
                        if(!job.empty?)
                        
                        len = job.length-1
                        puts len
                        for x in 0..len
                                puts "satisfy"
                            need = [job[x].maxres,job[x].allocres].transpose.map{|x| x.reduce(:-)}                       
                            satisfy = available.zip(need).map { |x, y| x >= y }.include?(false) # [true, false, true]  
                            if(!satisfy)
                                puts "pinasok"
                                available = [available,need].transpose.map{|x| x.reduce(:-)} 
                                ready.push(job[x])
                                job[x] = nil
                            end
                        end
                        job.compact!
                        end
                        if(!ready.empty?)
                            puts "not"
                        
                            slot.append{
                                 if(done == true)
                                   ready.sort_by!{|obj| obj.priority_no}
                                   done = false
                                end 

                                if ready[0].waiting_time.nil?
                                    ready[0].response_time = count 
                                end

                                if(currProcess != ready[0].number || ready[0].waiting_time.nil?)
                                     ready[0].waiting_time = count - ready[0].arrival_time     
                                end

                                currProcess = ready[0].number
                                ready.sort_by!{|obj| obj.cputime}
                                process = ready[0]
                                stroke process.color
                                fill process.color
                                rect x1, 20, 20, 30
                                
                                if(curColor != process.color)
                                    stack :left=> x1-5, :top =>55, :width=>30, :height=> 20  do
                                        inscription count
                                    end 
                                    curColor = process.color
                                end
                                x1+=20
                                count+=1
                                ready[0].cputime -= 1
                            puts ready[0].cputime
                                stack :top => 200, :left => 0 do 
                                    
                                        
                                        cyVal << cylinders[0]
                                        if(cylinders.length > 1)
                                            cylinders.shift
                                        end
                                        x_axis2 << count.to_s 
                                    
                                
                                    ready[0].cylinders.shift
                                    @cs[no].color = process.color
                                    @plots[no].redraw_to(cyVal.length)
                            end
                        
                            if(ready[0].cputime <= 0)
                                ready[0].turn_around = count - ready[0].arrival_time
                                available = [available,ready[0].maxres].transpose.map{|x| x.reduce(:+)}
                                ready.shift
                                done =true
                            end 
                            }
                        
                        
                            
                        elsif(job.empty? || ready.empty?)
                        slot.append{
                            stroke rgb(128,128,128)
                            fill rgb(128,128,128)   
                            rect x1, 20, 20, 30
                        
                        

                            if(curColor != rgb(128,128,128))
                                stack :left=> x1-5, :top =>55, :width=>30, :height=> 20  do
                                    inscription count
                                end 
                                curColor = rgb(128,128,128)
                            end
                            x1+=20
                            count+=1
                          
                        }    
                        end
            
                    end
                end 
           end

               
             
        
        }
    end

    def RR(processArr, x, y, w=473, h, diskalgo, no, quanta, cylinders, diskUsed)
         @coco.append(){
           ready = []
           job = [] 
           quanter = 0
           currProcess = -1
           puts "quanta #{quanta}"
           cypass = cylinders.dup
           processArr = processArr.map!{|a| a.dup}
           processArr = processArr.each do |a| a.cylinders = a.cylinders.dup end
           processArr.sort_by!{|obj| obj.arrival_time}
           processArr.each{|a| puts a.arrival_time}
           vectors = @vectors.dup
           vectors.shift
           processes = processArr.dup
           available = vectors.map{|a| a.text.to_i}
           x1 = 2
           curColor = nil 
           cyVal = [@headCy.text.to_i,@headCy.text.to_i]
           puts "#{cyVal}"
           x_axis2 = ["0", "0"]
           chart =  stack :top => y + 100, :left => x do 
                
                plot_area = stack do
                      @plots[no] = plot 320, 300, title: diskUsed, caption: "X:Time Y: Sector",
                            font: "Helvetica", auto_grid: true, default: "skip", background: white
                     @cs[no] = chart_series values: cyVal, labels: x_axis2, name: "foobar", 
                            min: 0, max: @maxCy.text.to_i+5 , desc: "Sectors Movement", color: rgb(rand(255),rand(255), rand(555)),
                            points: true     
                      @plots[no].add @cs[no] 
                end

                 @stats[no] = flow :left=>500, :top=> 0 do end
           end  
           stack :left=> x, :top=> y do 
                para "Simulation #{no} Round Robin", :align=>"center", :weight=> "semibold", :emphasis => "italic"
                border black, :strokewidth => 2    
                count = 0
                slot = flow :top=>0 do end
                flow :top=> 80, :left=> 0 do
                    back_button = image "back.png"
                    back_button.click{
                        puts "#{slot.width}"
                        slot.move slot.left - 10 , slot.top
                    }
                    forward_button = image "forward.png", :margin_left=>870
                    forward_button.click{
                        if(slot.left !=0)
                        slot.move slot.left + 10 , slot.top
                        end
                    }
                end
                slot.clear{}
                puts processArr.empty? && job.empty? && ready.empty?
               @everies[no] = every @speed do
                    if(x1 > w) 
                        slot.move slot.left - 10 , 0 
                    end
                    if(processArr.empty? && job.empty? && ready.empty?)
                         @everies[no].stop
                        slot.append(){
                            stack :left=> x1-5, :top =>55, :width=>20, :height=> 20  do
                                inscription count
                            end   
                        }  
                        @stats[no].clear(){
                            displayStat(processes, cypass)
                        } 
                    elsif(processArr.empty? && !job.empty? && ready.empty?)
                        @everies[no].stop
                        slot.append(){
                            stack :left=> x1-5, :top =>55, :width=>30, :height=> 20  do
                                inscription count
                            end
                            
                        } 
                        alert("Deadlock", :title => nil) 
                    else
                        if(!processArr.empty?)
                            job+=processArr.select { |favor| favor.arrival_time == count }
                            processArr.select! { |favor| favor.arrival_time != count }
                        end
                        if(!job.empty?)
                        
                        len = job.length-1
                        for x in 0..len
                            need = [job[x].maxres,job[x].allocres].transpose.map{|x| x.reduce(:-)}                       
                            satisfy = available.zip(need).map { |x, y| x >= y }.include?(false) # [true, false, true]  
                            if(!satisfy)
                                available = [available,need].transpose.map{|x| x.reduce(:-)} 
                                ready.push(job[x])
                                job[x] = nil
                            end
                        end
                        job.compact!
                        end
                        if(!ready.empty?)
                             if(quanter==quanta)
                                puts "hallers"
                                cess = ready.shift
                                ready.push(cess)
                                quanter = 0
                            end
                            slot.append{  
                                
                                process = ready[0]
                                if ready[0].waiting_time.nil?
                                    ready[0].response_time = count 
                                end 

                                if(currProcess != ready[0].number || ready[0].waiting_time.nil?)
                                     ready[0].waiting_time =  ready[0].waiting_time.to_i + (count - ready[0].arrival_time)     
                                end

                                currProcess = ready[0].number
                                stroke process.color
                                fill process.color
                                rect x1, 20, 20, 30
                                
                                if(curColor != process.color)
                                    stack :left=> x1-5, :top =>55, :width=>30, :height=> 20  do
                                        inscription count
                                    end 
                                    curColor = process.color
                                end
                                x1+=20
                                count+=1
                                ready[0].cputime -= 1
                                stack :top => 200, :left => 0 do 
                                    
                                        
                                        cyVal << cylinders[0]
                                        if(cylinders.length > 1)
                                            cylinders.shift
                                        end
                                        x_axis2 << count.to_s 
                                    
                                
                                    ready[0].cylinders.shift
                                    @cs[no].color = process.color
                                    @plots[no].redraw_to(cyVal.length)
                            end
                            quanter+=1
                            if(ready[0].cputime <= 0)
                                ready[0].turn_around = count -ready[0].arrival_time
                                ready[0].arrival_time = count
                                available = [available,ready[0].maxres].transpose.map{|x| x.reduce(:+)}
                                ready.shift
                            end 
                            
                        }
                        
                        
                            
                        elsif(job.empty? || ready.empty?)
                        slot.append{
                            stroke rgb(128,128,128)
                            fill rgb(128,128,128)   
                            rect x1, 20, 20, 30
                        
                        

                            if(curColor != rgb(128,128,128))
                                stack :left=> x1-5, :top =>55, :width=>30, :height=> 20  do
                                    inscription count
                                end 
                                curColor = rgb(128,128,128)
                            end
                            x1+=20
                            count+=1
                          
                        }    
                        end
                    
                    end
                end 
           end

               
             
        
        }
    end

    def diskFCFS()

    end

    def diskSSTF()
        toreturn = []
        toCompare = @headCy.text.to_i
        newCylinders = @cylinders.dup
        index = 0
        lowest = Float::INFINITY
        puts "Head: #{toCompare}"
        puts "Cylinders: #{newCylinders}"
        for x in 0..@cylinders.length-1
            puts "length: #{newCylinders.length-1}"
            for j in 0..newCylinders.length-1
               if((newCylinders[j] - toCompare).abs < lowest)
                    lowest = (newCylinders[j] - toCompare).abs 
                    index = j 
               end
            end
            toreturn.push(newCylinders[index])
            toCompare = newCylinders[index]
            lowest = Float::INFINITY
            newCylinders.delete_at(index)
        end
        puts "toreturn #{toreturn}"
        return toreturn
    end

    def diskSCAN()
        toreturn = []
        isleft = @headCy.text.to_i - @prevCy.text.to_i < 0 ? true : false
        toCompare = @headCy.text.to_i
        newCylinders = @cylinders.dup.sort!
        head = @headCy.text.to_i
        start= -1
        puts "hello"
        puts "#{isleft}"
        puts "Cylinders: #{newCylinders}" 
        if isleft == true
            for j in 0..newCylinders.length-1        
                if( newCylinders[j]  <= head)
                    start = j
                end
            end

            toreturn += newCylinders.slice(0,start+1).reverse
            if(!(toreturn.include? 0))
                toreturn.push(0)
            end
            toreturn += newCylinders.slice(start+1, newCylinders.length - start+1)
        else
            for j in 0..newCylinders.length-1        
                if(newCylinders[j]  >= head)
                    start = j
                    break
                end
            end
            toreturn += newCylinders.slice(start,newCylinders.length - start)
            puts "#{start}"
            if(!(toreturn.include? @maxCy.text.to_i))
                toreturn.push(@maxCy.text.to_i)
            end
            toreturn += newCylinders.slice(0, start).reverse
        end
        puts "toreturn #{toreturn}"
        return toreturn
    end

    def diskCSCAN()
        toreturn = []
        isleft = @headCy.text.to_i - @prevCy.text.to_i < 0 ? true : false
        toCompare = @headCy.text.to_i
        newCylinders = @cylinders.dup.sort!
        head = @headCy.text.to_i
        start= -1
        puts "hello"
        puts "#{isleft}"
        puts "Cylinders: #{newCylinders}" 
        if isleft == true
            puts "hello"
            for j in 0..newCylinders.length-1        
                if( newCylinders[j]  <= head)
                    start = j
                end
            end

            toreturn += newCylinders.slice(0,start+1).reverse
            if(!(toreturn.include? 0))
                toreturn.push(0)
            end
            if(!(toreturn.include? @maxCy.text.to_i )  && !(newCylinders.include? @maxCy.text.to_i))
                toreturn.push(@maxCy.text.to_i)
            end
            toreturn += newCylinders.slice(start+1, newCylinders.length - start+1).reverse
        else
        
            for j in 0..newCylinders.length-1        
                if(newCylinders[j]  >= head)
                    start = j
                    break
                end
            end
            
            toreturn += newCylinders.slice(start,newCylinders.length - start)
          
            puts "#{start}"
            if(!(toreturn.include? @maxCy.text.to_i))
                toreturn.push(@maxCy.text.to_i)
            end
            puts "ayay"
            if(!(toreturn.include? 0 )  && !(newCylinders.include? 0))
                toreturn.push(0)
            end
            toreturn += newCylinders.slice(0, start)
            
        end
        puts "toreturn #{toreturn}"
        return toreturn
    end 

    def diskLook()
        toreturn = []
        isleft = @headCy.text.to_i - @prevCy.text.to_i < 0 ? true : false
        toCompare = @headCy.text.to_i
        newCylinders = @cylinders.dup.sort!
        head = @headCy.text.to_i
        start= -1
        puts "hello"
        puts "#{isleft}"
        puts "Cylinders: #{newCylinders}" 
        if isleft == true
            for j in 0..newCylinders.length-1        
                if( newCylinders[j]  <= head)
                    start = j
                end
            end

            toreturn += newCylinders.slice(0,start+1).reverse
            toreturn += newCylinders.slice(start+1, newCylinders.length - start+1)
        else
            for j in 0..newCylinders.length-1        
                if(newCylinders[j]  >= head)
                    start = j
                    break
                end
            end
            toreturn += newCylinders.slice(start,newCylinders.length - start)
            puts "#{start}"
            toreturn += newCylinders.slice(0, start).reverse
        end
        puts "toreturn #{toreturn}"
        return toreturn
    end

    def diskCLook()
        toreturn = []
        isleft = @headCy.text.to_i - @prevCy.text.to_i < 0 ? true : false
        toCompare = @headCy.text.to_i
        newCylinders = @cylinders.dup.sort!
        head = @headCy.text.to_i
        start= -1
        puts "hello"
        puts "#{isleft}"
        puts "Cylinders: #{newCylinders}" 
        if isleft == true
            puts "hello"
            for j in 0..newCylinders.length-1        
                if( newCylinders[j]  <= head)
                    start = j
                end
            end

            toreturn += newCylinders.slice(0,start+1).reverse
            toreturn += newCylinders.slice(start+1, newCylinders.length - start+1).reverse
        else
        
            for j in 0..newCylinders.length-1        
                if(newCylinders[j]  >= head)
                    start = j
                    break
                end
            end
            
            toreturn += newCylinders.slice(start,newCylinders.length - start)
            toreturn += newCylinders.slice(0, start)
            
        end
        puts "toreturn #{toreturn}"
        return toreturn
    end
    fill white
    @algolist = []
    @simulations = []
    @disklist = []
    @quantumTimes = [-1,-1,-1,-1,-1,-1]
    @cpualgos = []
    @diskAlgos = []
    @@noRes = 1
    @vectors = [] 
    @maxVectors = []
    @allocVectors = []
    @cylinders = []     
    @processNo = 1
    @processes = []
    @colors = []
    @threads = []
    @stats = Hash.new
    @speed = 1
    @plots = Hash.new
    @cs = Hash.new
    @everies = Hash.new
    @mutex = Mutex.new
   
    @processInputs = flow :width=> 420, :height => 768, :top => 0, :left => 0 do 
      
    end

    @coco = flow :width=> 946, :height => 768, :top => 0, :left => 420, :scroll=>true do 
            background white
            # para "simulation"
    end 
       
    @slot = stack :width=> 420, :height => 768, :top => 0, :left => 0 do
         border black, :strokewidth => 5
         background silver
        @modelist = list_box :items => ["Single", "Comparative", "All"],
	     :width => 300, :choose => "Single" do |list|
	        
            @algorithms.clear()
            @simulations.clear()
            @algolist.clear()
            @cpualgos.clear()
            @diskAlgos.clear()
            if(list.text == "Single")
               count = 1
            elsif(list.text == "Comparative")
               count = 2
            elsif(list.text == "All")
               count = 6
            end
              
            for x in 1..count
                puts "SAF #{x}"
                @algorithms.append() {
                    algo(x)
                }
            end
            
         end
        @modelist.change(){
            @algorithms.clear()
            @simulations.clear()
            @algolist.clear()
            @cpualgos.clear()
            @diskAlgos.clear()
            if(@modelist.text == "Single")
               count = 1
            elsif(@modelist.text == "Comparative")
               count = 2
            elsif(@modelist.text == "All")
               count = 6
            end
              
            for x in 1..count
                @algorithms.append() {
                    algo(x)
                }
            end
        }
        @modelist.left = 55
        @modelist.top = 10  
        
      @algorithms = stack(:top => 20, :height => 400, :scroll => true, :margin_right=> 30) do 
           
       end

       stack(:top => 200)  do    
           flow(:top => 200, :left=>20) {
              para  "No of Resources:"
              @noRes = edit_line do |e|
                 e.text = e.text.sub( /\D/, '')
                 if(e.text.to_i > 10)
                    e.text = e.text[0..-2]
                 end
                 @vectors.clear()
                 @vectorAreas.clear()
                 @vectorAreas.append(){
                    @vectors.push(edit = edit_line(:width=>30) do |e|
                        e.text = ''
                    end) 
                    edit.state = "disabled"
                 } 
                 for x in 1..e.text.to_i-1   
                     @vectorAreas.append(){
                          @vectors.push(edit_line(:width=>30)) 
                      }
                     
                 end
              end 
              @noRes.text = 1 
           }    
      
           flow(:top => 240, :left=>20) {
              para  "Max Cyclinder: "
              @maxCy = edit_line do |e|
                 e.text = e.text.sub( /\D/, '')
              end 
              @maxCy.text = 0 
           }    

           flow(:top => 280, :left=>20) {
              para  "Head Cylinder: "
              @headCy = edit_line do |e|
                 if(e.text.to_i > @maxCy.text.to_i)
                    e.text = e.text.chop
                 end
                 e.text = e.text.sub( /\D/, '')
              end
              @headCy.text = 0       
           } 
           
           flow(:top => 320, :left=>20) {
              para  "Previous Cylinder: "
              @prevCy = edit_line do |e|
                 if(e.text.to_i > @maxCy.text.to_i)
                    e.text = e.text.chop
                 end
                 e.text = e.text.sub( /\D/, '')
              end
              @prevCy.text = 0       
           }   
        
        end 
             
        stack(:margin=> 30) do
           para "Available Vector"
		   @vectorAreas = flow do
			   @vectors.push(edit = edit_line(:width=>30) do |e|
			       e.text = ''
               end)  
               edit.state = "disabled"
           end 
        end 

        button "          OK           ", :left=> 70, :top=>650 do
             puts "#{@cpualgos}"
             @slot.hide() 
             @processInputs.clear(){
                 puts "#{@diskAlgos}"
                  border black, :strokewidth => 5     
                  background silver
                 @topProcess = 50 
                 @processInput = stack(:width => 400, :height => 290, :top => 10, :margin_left => 20, :margin_top => 30, :scroll => true) do
                    background gainsboro, scroll: true
                    
                    @textP = caption "Process #{@processNo}" 
                    @textP.align = "center"
                    
                    flow{ 
                        para "Arrival Time:          " 
                        @arrivalTime = edit_line do |e|
                            e.text = e.text.sub( /\D/, '')
                        end
                        @arrivalTime.text = 0
                    }
                    a= flow{}
                    conPrio = @cpualgos.include?("Priority  Sched") || @cpualgos.include?("Preemptive-Priority Sched")
                    if(conPrio)
                        a.append(){
                           para "PRIORITY NUMBER:          " 
                           @prio_no = edit_line :width=>150 do |e|
                              e.text = e.text.sub( /\D/, '')
                           end 
                        }   
                        @prio_no.text = 1
                    end 
                    flow :margin_left => 140 do para "Max Vector" end 
                    @maxVector = flow{} 
                        
                    

                    flow :margin_left => 130 do para "Allocated Vector" end
                    @allowVector = flow{}
                        
                    
                    # flow{
                    #     para "Cylinders "
                    #     @cylindersArea = flow{}
                    #     @cylindersArea.append(){
                    #         @cylinders.push(edit_line(:width=>30)) 
                    #     } 
                    # } 
                   
                    flow :margin_left => 100 do
                        @add = button "Add" 
                        @add.click{
                            @processNo+=1
                            @textP.text =  "Process #{@processNo}" 
                            
                            maxVec = []
                            allocVec = []
                            cylinder = []
                            color = rgb(rand(256), rand(256), rand(256))
                            gray  = rgb(128,128,128)
                            
                            for x in 0..@vectors.length-1
                                puts @maxVectors[x].text.to_i
                                puts @allocVectors[x].text.to_i
                                maxVec.push(@maxVectors[x].text.to_i)
                                allocVec.push(@allocVectors[x].text.to_i)
                            end
                                            
                            puts "max: #{maxVec}"
                            # for x in 0..@cylinders.length-1
                            #     puts @cylinders[x].text.to_i
                            #     cylinder.push(@cylinders[x].text.to_i)
                            # end
                            
                            while @colors.include?(color) || color == gray do 
                                color = rgb(rand(256), rand(256), rand(256))
                            end
                            puts "hahahaha"
                            puts color
                            @colors.push(color)
                            # alert color + " " + maxVec + " " + cylinder + " " + allocVec 
                            arrivalTime = @arrivalTime.text.to_i
                            prio = @prio_no.nil? ? -1 : @prio_no.text.to_i
                            puts prio
                            puts arrivalTime
                            # number, color, arrival_time, allocres, maxres, cylinders, priority_no = -1
                            puts cylinder
                            process1 = Simulator::Processo.new @processNo-1, color, arrivalTime, allocVec, maxVec, cylinder, prio
                           
                            @processes.push(process1)
                            @processChuChu.append(){
                                flow do
                                    left = 10
                                    add = 0 
                                    label = ["", process1.number.to_s, process1.arrival_time, process1.maxres.join(","), process1.allocres.join(",")]
                                    if(!@prio_no.nil?)
                                       label.push(process1.priority_no.to_s)
                                    end
                                    for x in 0..label.length-1
                                        if(x==0)
                                           fill process1.color
                                        else
                                           fill aqua
                                        end
                                        rect left, @topProcess, @dims[x], 50
                                        if ( x > 2 ) 
                                            add = 10
                                        end
                                        
                                       if(label[x].respond_to?('each'))
                                            puts "Hello #{label[x]}"
                                             a =  label[x].each_slice(5).to_a
                                             y = 0
                                             for i in a
                                                puts i
                                              
                                                inscription " #{i.join(',')}" , :left=> left + add - 10 , :top =>@topProcess  +20* y, :width=> @dims[x], :height=> 40   
                                                y += 1
                                             end

                                        else
                                            stack :left=> left + add , :top =>@topProcess + 5, :width=> @dims[x], :height=> 40  do
                                                inscription label[x]
                                            end
                                        end
                                        left+= @dims[x]
                                    end 
                                    @topProcess += 40
                                end
                                process1.remove
                            }

                        }
                        
                        # button "Reset" do
                            
                        # end      
                    end 
                    
                

                end 
                 @processArea = stack :top=> 300, :height => 300, :scroll => true do
                    background silver
                    flow do
                    @dims = [40, 40,50, 90, 90, 90] 
                    label = ["Color", "Proc No", "Arrival Time", "Max Vector", "Allocated Vector"]
                    conPrio = @cpualgos.include?("Priority  Sched") || @cpualgos.include?("Preemptive-Priority Sched") 
                    if(conPrio)
                        left = 5
                        @dims = [30, 30,40, 90, 90, 90,40] 
                        label.push("Prio No.")
                    else
                        left = 10
                    end
                    left = 10 
                    add = 0 
                    for x in 0..label.length-1
                        fill aqua
                        rect left, 10, @dims[x], 50
                        if ( x > 2 ) 
                            add = 10
                        end
                        a = flow :left=> left + add , :top => 5, :width=> @dims[x], :height=> 40  do
                            
                        end
                        a.append(){
                            inscription label[x]
                        }
                        left+= @dims[x]
                    end 
                end
                @processChuChu = flow do end
                 para <<-'END'
  






          
                    





















                    END
            end
            
           
                

                flow(:margin_left => 50, :margin_top => 10) do 
                    edit_button = image "edit.png"
                    edit_button.click{
                        @slot.show()
                        # @cylinders.clear()
                        @processInputs.clear()
                        @processNo = 1
                        @processes.clear() 
                        @allocVectors.clear()
                        @maxVectors.clear()
                    }

                    @userdefbutt = button "User Defined"do  
                         
                    end
                    
                    @randombutt = button "  Randomized  " do
                        @processChuChu.clear(){} 
                        @processes.clear(){}   
                        @plots.clear()
                        @cs.clear()
                        @everies.clear()
                        @add.state = "disabled"
                        @userdefbutt.state = "disabled" 
                        @topProcess = 50 
                        for x in 1..rand(21)
                            processNo = x
                            maxVec = []
                            allocVec = []
                            cylinder = []
                            color = rgb(rand(256), rand(256), rand(256))
                            gray  = rgb(128,128,128)
                            for x in 0..@vectors.length-1
                                max = x==0 ? rand(1..21) : rand(@vectors[x].text.to_i+1)
                                maxVec.push(max)
                                allocVec.push(rand(max+1))
                            end
                                         
                            # for x in 1..maxVec[0] 
                            #     cylinder.push(rand(@maxCy.text.to_i+1))
                            # end
                            
                            while @colors.include?(color) || color == gray do 
                                color = rgb(rand(256), rand(256), rand(256))
                            end
                            puts color
                            @colors.push(color)
                            # alert color + " " + maxVec + " " + cylinder + " " + allocVec 
                            arrivalTime = rand(21)
                            prio = @cpualgos.include?("Priority  Sched") || @cpualgos.include?("Preemptive-Priority Sched") ? rand(100) : -1
                            puts prio
                            puts arrivalTime
                            # number, color, arrival_time, allocres, maxres, cylinders, priority_no = -1
                            puts cylinder
                            process1 = Simulator::Processo.new processNo, color, arrivalTime, allocVec, maxVec, cylinder, prio
                           
                            @processes.push(process1)
                            @processChuChu.append(){
                                flow do
                                    left = 10
                                    add = 0 
                                    label = ["", process1.number.to_s, process1.arrival_time, process1.maxres, process1.allocres]
                                    if(@cpualgos.include?("Priority  Sched") || @cpualgos.include?("Preemptive-Priority Sched"))
                                       label.push(process1.priority_no.to_s)
                                    end
                                    for x in 0..label.length-1
                                        if(x==0)
                                           fill process1.color
                                        else
                                           fill aqua
                                        end
                                        rect left, @topProcess, @dims[x], 50
                                        if ( x > 2 ) 
                                            add = 10
                                        end
                                         if(label[x].respond_to?('each'))
                                            puts "Hello #{label[x]}"
                                             a =  label[x].each_slice(5).to_a
                                             y = 0
                                             for i in a
                                                puts i
                                              
                                                inscription " #{i.join(',')}" , :left=> left + add - 10 , :top =>@topProcess  +20* y, :width=> @dims[x], :height=> 40   
                                                y += 1
                                             end

                                        else
                                            stack :left=> left + add , :top =>@topProcess + 5, :width=> @dims[x], :height=> 40  do
                                                inscription label[x]
                                            end
                                        end
                                        left+= @dims[x]
                                    end 
                                    @topProcess += 40
                                end
                                process1.remove
                            }
                        end
                    end  
                end 


            @controller = flow(:margin_top => 600, :margin_left => 60) do
                    
                     @speeddown = image "back.png"
                     @speeddown.click(){
                         puts @speed
                         if(@speed < 2)
                             @speed /=0.25
                              @speedText.text = "#{(1/@speed).to_f.round(2)}x"
                         end 
                     }

                     @play_pause = image "pause.png"
                     @play_pause.click(){
                         puts @play_pause.path
                         if(@play_pause.path == "pause.png")
                            puts "ssd"
                               @play_pause.path = "play.png"    
                              @everies.each_value{|value| value.toggle}
                             
                         else 
                            @everies.each_value{|value| value.toggle}
                              @play_pause.path = "pause.png" 
                         end        
                     }
                      @speedup =  image "forward.png"  
                    @speedup.click(){
                         puts @speed
                         @speed *=0.5 
                          @speedText.text = "#{(1/@speed).to_f.round(2)}x"
                     }
                     @speedText = para "#{(1/@speed).to_f.round(2)}x"
                
                button "Start"do
                    @play_pause.path = "pause.png" 
                    @coco.clear(){}
                    simulations = []
                    @cs.clear()
                    @plots.clear()
                    @everies.clear()
                    @stats.clear()
                   puts "cpualgos: #{@cpualgos}" 
                   puts "diskalgos: #{@diskAlgos}"
                   puts "quanta: #{@quantumTimes}"   
                    for x in 0..@cpualgos.length-1
                        simulations.push(Simulator::Simulation.new(@cpualgos[x], @diskAlgos[x], x+1, @quantumTimes[x]))
                    end
                    sleep(0.1)
                   sum = 0
                   for x in 0..@processes.length-1
                       sum += @processes[x].cputime
                   end
                   puts "sum #{sum}"
                   @cylinders.clear()
                   for x in 1..sum
                        @cylinders.push(rand(@maxCy.text.to_i+1))
                   end 
                  
                   puts "stop"
                   for x in 0..simulations.length-1 
                      if simulations[x].disksim == "FCFS"
                            cylinders  = @cylinders.dup
                            diskUsed = "FCFS"
                      elsif simulations[x].disksim == "SSTF"
                            cylinders = diskSSTF()
                            diskUsed = "SSTF"
                      elsif simulations[x].disksim == "SCAN"
                            cylinders = diskSCAN()
                            diskUsed = "SCAN"
                      elsif simulations[x].disksim == "C-SCAN"
                            cylinders = diskCSCAN()
                            diskUsed = "C-SCAN"
                      elsif simulations[x].disksim == "LOOK"
                            cylinders = diskLook()
                            diskUsed = "LOOK"
                      elsif simulations[x].disksim == "CLOOK"
                            cylinders = diskCLook()
                            diskUsed = "CLOOK"
                      end
                      puts "CYLINDERS HAHA: #{cylinders}"
                      if(simulations[x].cpusim == "FCFS")
                        puts "sdsd"
                        FCFS(@processes.dup,0, x*400,500, 0, simulations[x].disksim, x+1, cylinders, diskUsed)
                      elsif(simulations[x].cpusim == "SJF")  
                        SJF(@processes.dup,0, x*400,500, 0, simulations[x].disksim, x+1, cylinders, diskUsed) 
                      elsif(simulations[x].cpusim == "SRTF")  
                        SRTF(@processes.dup,0, x*400,500, 0, simulations[x].disksim, x+1, cylinders, diskUsed) 
                      elsif(simulations[x].cpusim == "Preemptive-Priority Sched")
                        PRIO(@processes.dup,0, x*400,500, 0, simulations[x].disksim, x+1, cylinders, diskUsed)
                      elsif(simulations[x].cpusim == "Priority  Sched")
                        NPPRIO(@processes.dup,0, x*400,500, 0, simulations[x].disksim, x+1, cylinders, diskUsed)
                      elsif(simulations[x].cpusim == "Round Robin")  
                        RR(@processes.dup,0, x*400,500, 0, simulations[x].disksim, x+1, simulations[x].quanta, cylinders, diskUsed)
                      end
                   end  
                                 
                end
                
                button "Reset" do
                    @processNo = 1
                    @textP.text =  "Process #{@processNo}" 
                    @processChuChu.clear(){} 
                    @coco.clear()
                    @processes.clear(){}   
                    @userdefbutt.state = nil
                    @randombutt.state = nil
                    @plots.clear()
                    @cs.clear()
                    @everies.clear()
                    @add.state = nil
                    @topProcess = 40 
                end  

                   
                 end

          
           
                

                        

            @processInput.hide()
            @processInputs.hide()

             }
              @allowVector.append(){
                edit = edit_line(:width=>30) do |e|
                     e.text = e.text.sub( /\D/, '')
                end
                edit.state = "disabled"
                @allocVectors.push(edit)
             }
             for x in 2..@vectors.length
                 @allowVector.append(){
		             @allocVectors.push(edit_line(:width=>30) do |e|
		                e.text = e.text.sub( /\D/, '')
                     end)       
                 }
              end  
              @maxVector.append(){ 
                edit = edit_line(:width=>30) do |e|
                     e.text = e.text.sub( /\D/, '')
                     if(e.text.to_i > 20)
                        e.text = e.text[0..-2]
                     end
                    # @cylinders.clear()
                    # @cylindersArea.clear()
                    # @cylindersArea.append(){
                    # @cylinders.push(edit_line(:width=>30) do |e|
                       
                    # end) 
                    # } 
                    # for x in 1..e.text.to_i-1   
                    #     @cylindersArea.append(){
                    #         @cylinders.push(edit_line(:width=>30)) 
                    #     }  
                    # end
                end
                @maxVectors.push(edit)
                edit.text = 1
                
              }
              for x in 2..@vectors.length
                 puts @vectors.length
                 @maxVector.append(){ 
		             @maxVectors.push(edit_line(:width=>30) do |e|
		                e.text = e.text.sub( /\D/, '')
		             end)
                 }
              end  
             @processInputs.show() 
             @processInput.show()
             @processInput.scroll = true
        end  
        
      
        
       
    end
    

    
end

  

