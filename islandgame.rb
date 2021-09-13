require "./islemod.rb"

$timepassed = 0

class Area
    
    @@wood = 0
    @@palm = 0
    @@fish = 0
    @@water = 0
    
    def enter()
        puts "This area is not yet configured. Subclass it and implement enter()."
    exit(1)
    end

end

class Engine
    def initialize(area_map)
        @area_map = area_map
    end

    def play()
        current_area = @area_map.opening_area()
        last_area = @area_map.next_area('sail')

        while current_area != last_area
            next_area_name = current_area.enter()
            current_area = @area_map.next_area(next_area_name)
        end

        current_area.enter()
    end
end

class Status < Area 
    def enter()
        puts "You have #{@@wood} wood, #{@@water} water, #{@@palm} palm, and #{@@fish} fish.\n\n"
        puts """Where would you like to go?
            1. Beach
            2. Ocean
            3. River
            4. Forest
            5. Path
            6. Peak"""
        print "> "
        choice = $stdin.gets.chomp
    
        if choice == "1" 
            Title.clear(); return 'beach'
        elsif choice == "2" 
            Title.clear(); return 'ocean'
        elsif choice == "3" 
            Title.clear(); return 'river'
        elsif choice == "4" 
            Title.clear(); return 'forest'
        elsif choice == "5"
            Title.clear(); return 'path'
        elsif choice == "6"
            Title.clear(); return 'peak'
        else
            puts "Pick a number, 1-6"
            Title.clear(); return 'status'
        end
    end 
end

class GameReset < Area

    def enter()
        puts "Resetting game."
        @@wood = 0; @@palm = 0; @@fish = 0; @@water = 0; $timepassed = 0
        Title.ent(); return 'beach'
    end
end

class Beach < Area
    def enter()
        if $timepassed < 12
            puts """
            You find yourself on the beach of a deserted island. You see tall
            palm trees dotting the coastline. There's an endless expanse of
            crystal clear water out in front of you, the waves slowly rolling
            in.

            Further inland you see a heavily wooded area.
            """
        else
            puts """
            The sun sunk behind the horizon. The quiet, peaceful beach seems
            much more menancing in the darkness.

            On the plus side, the night sky is breathtaking.
            """
        end
        
        print "> "
        choice = $stdin.gets.chomp

        if choice.include? "ocean"
            PT.now(); Title.clear(); return 'ocean'
                
        elsif choice.include? "forest"
            PT.now(); Title.clear(); return 'forest'

        elsif choice.include? "palm"
            puts "You collect palm fronds."; @@palm = 1
            Title.ent(); return 'beach'

        elsif choice == "build raft" && !(@@fish == 1 && @@wood == 1 && @@palm == 1 && @@water == 1)
            puts "You don't have the materials to build a raft."
            Title.ent(); return 'beach'
        
        elsif choice == "build raft" && (@@fish == 1 && @@wood == 1 && @@palm == 1 && @@water == 1)
            puts "You build a raft."
            PT.now(); Title.ent(); return 'sail'

        elsif choice == "status"
            Title.clear(); return 'status'

        elsif choice == "ladder"
            PT.now(); Title.clear(); return 'ladder'

        else
            puts "The sound of the waves is soothing."
            PT.now(); Title.ent(); return 'beach'
        end
    end
end

class Ocean < Area
    def enter()
        if $timepassed < 12
            puts """
            You wade out into the calm surf. Through the clear blue water
            you can see small fish swimming about. The bottom is sandy and
            soft under your bare feet. Strands of seaweed float nearby.
            """
        
        else
            puts """
            The ocean is dark and inpenetrible. The only light is of the distant
            stars in the night sky. You can only tell where the island is by
            the looming starless shadow.

            You feel creatures brush by you in the darkness.
            """
        end

        print "> "
        choice = $stdin.gets.chomp

        if choice == "fish" && (@@fish == 0)
            puts "You snatch a fish with your bare hands"; @@fish = 1
            PT.now(); Title.ent(); return 'ocean'

        elsif choice == "fish" && (@@fish == 1)
            puts "You already have a fish."
            Title.ent(); return 'ocean'
              
        elsif choice.include? "beach"
            PT.now(); Title.clear(); return 'beach'

        else
            puts "The ebb and flow of the water calms you."
            PT.now(); Title.ent(); return 'ocean'
        end
    end
end

class Forest < Area
    def enter()
        if $timepassed < 12
            puts """
            The beach quickly gives way to a dense forest. A thick 
            canopy covers the area. There are fallen trees and logs
            scattered.

            You hear the faint sound of running water.
            """
        else
            puts """
            With the sun gone, the forest is dense sea of darkness.
            As you stumble around, you hear the rustling of creatures
            on the forest floor.

            You hear the clear sound of running water.
            """
        end

        print "> "
        choice = $stdin.gets.chomp

        if choice == "wood" && @@wood == 0
            puts "You collect wood."; @@wood = 1
            PT.now(); Title.ent(); return 'forest'
        
        elsif choice == "wood" && @@wood == 1
            puts "You already have wood."
            Title.ent(); return 'forest'

        elsif choice.include? "river"
            PT.now(); Title.clear(); return 'river'

        elsif choice.include? "beach"
            PT.now(); Title.clear(); return 'beach'

        elsif choice.include? "path"
            PT.twice(); Title.clear(); return 'path'

        else
            puts "A gentle breeze rustles the leaves."
            PT.now(); Title.ent(); return 'forest'
        end
    end
end

class River < Area
    def enter()
        if $timepassed < 12
            puts """
            You come across a calm and steady stream. It flows from the 
            highlands through the forest across a sandy bottom into the 
            sea.

            There are fucking otters.
            """

        else
            puts """
            You can hear the steady stream and catch glimpses of starlight
            reflecting in the flowing water.

            You suppose the otters have retired for the night.

            You suppose that because you can't see much of anything and you
            are pretty sure otters aren't nocturnal.
            """
        end

        print "> "
        choice = $stdin.gets.chomp

        if choice == "water" && @@water == 0
            puts "You collect drinking water."; @@water = 1
            PT.now(); Title.ent(); return 'river'

        elsif choice == "water" && @@water == 1
            puts "You have water."
            Title.ent(); return 'river'

        elsif choice == "otter" && $timepassed > 11
            puts "The otters are asleep."
            Title.ent(); return 'river'
        
        elsif choice == "otter" 
            puts "You pet the otters, because they are the greatest."
            PT.now(); Title.ent(); return 'river'

        elsif choice.include? "forest"
            PT.now(); Title.clear(); return 'forest'

        else
            puts "The babbling brook steadily flows along a shallow sandy riverbed."
            PT.now(); Title.ent(); return 'river'
        end
    end
end

class Path  < Area
    def enter()
        if $timepassed < 12
            puts "You come to a winding path up the mountain peak."

        else
            puts """
            You can see the silhouette of the looming mountain among the stars. The wind howls.
            Given nightfall and the conditions, it's probably not a good idea to attempt the climb.
            """
        end
        print "> "
        choice = $stdin.gets.chomp
        if $timepassed > 11
            PT.twice(); Title.ent(); return 'forest'
        
        elsif choice.include? 'mountain'
            PT.twice(); Title.ent(); return 'peak'

        elsif choice.include? 'forest'
            PT.twice(); Title.ent(); return 'peak'

        else
            puts "The winds are strong along the mountain path."
        end      
    end
end

class Peak < Area
    def enter()
        if $timepassed < 12
            puts "Mountain peak."

        else
            puts "Dark description. Peak not accessible yet."
        end

        PT.now(); Title.ent(); return 'beach'
    end
end

class Sail < Area
    def enter()
        if $timepassed < 12
            puts "You build a raft and push away from the island, sailing"
            puts "into a deep blue ocean."

        else
            puts "You build a raft and push out into the ever expanding darkness"
            puts "of a quiet ocean under starlight."
        end

        exit(1)
    end

end

class Ladder < Area
    def enter()
        if $timepassed < 12
            puts "By complete happenstance, you happen what feels like an invisible ladder.\n\n"
            puts"""
            You scale, carefully, this camouflaged ladder for a few hundred feet.
            Looking up, you notice the sky looks off and unaligned. As you climb higher,
            you feel a 'ceiling'. You feel around the bottom of this box in the sky until
            you feel a handle.
            """

        else
            puts "You feel the rungs of a ladder. You don't recall ever seeing a ladder in the"
            puts "daylight. You imagine it must be heavily camouflaged.\n\n"
            puts """
            You scale, carefully, this camouflaged ladder for a few hundred feet.
            Looking up, you notice the sky looks off and unaligned. As you climb higher,
            you feel a 'ceiling'. You feel around the bottom of this box in the sky until
            you feel a handle.
            """
        end

        print "> "
        action = $stdin.gets.chomp

        if action.include? "open"
            puts "You open the door and head inside."
            PT.now(); Title.ent(); return 'skybox'
        else
            puts "Better not to interfere in things this strange. You head back down"
            puts "to the beach."
            PT.now(); Title.ent(); return 'beach'
        end
    end
end

class Skybox < Area
    def enter()
        if $timepassed < 12
            puts "Skybox description."

        else
            puts "Dark Skybox."
        end

        PT.now(); Title.ent(); return 'beach'
    end
end

class Map
    @@areas = {
        'beach' => Beach.new(),
        'ocean' => Ocean.new(),
        'forest' => Forest.new(),
        'river' => River.new(),
        'path' => Path.new(),
        'peak' => Peak.new(),
        'sail' => Sail.new(),
        'ladder' => Ladder.new(),
        'skybox' => Skybox.new(),
        'status' => Status.new(),
        'gamereset' => GameReset.new(),
    }


    def initialize(start_area)
        @start_area = start_area
    end


    def next_area(area_name)
        val = @@areas[area_name]
        return val
    end

    def opening_area()
        return next_area(@start_area)
    end
end

a_map = Map.new('beach')
a_game = Engine.new(a_map)
a_game.play()