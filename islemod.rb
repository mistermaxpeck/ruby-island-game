# modules for island game

# ideas for future
# - time passes slower on Mountain peak if nighttime
# - new module to reset the game
# - conditional for seeing glow on other side of island at night
# - rest function to reset time back to 0 in appropriate settings

module Title
 
    def Title.clear()
        # clears the screen
        print "\e[2J\e[f"
    end

    def Title.ent()
        puts "\n\npress enter to continue...\n"
        $stdin.gets.chomp
        Title.clear()
    end
end


# Module for basic passage of time. 0-11 treated as day; 12-23 as night. 
# The puts was added because it doesn't work without for some odd reason
module PT

    def PT.now()

        if $timepassed >= 23
            puts "A new day"
            $timepassed = 0
        
        else
            $timepassed += 1
        
        end
    end

    def PT.twice()
        
        if $timepassed >= 22
            puts "A new day"
            $timepassed = 0

        else
            $timepassed += 2
        
        end
    end

    def PT.half()

        if $timepassed >= 23
            puts "A new day"
            $timepassed = 0

        else
            $timepassed += 0.5
        end
    end

    def PT.rest()

        puts "Resting till morning."
        $timepassed = 0
    end
end