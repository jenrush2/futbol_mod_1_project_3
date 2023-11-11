class Team 
    attr_reader :team_id, 
                :franchiseid,
                :teamname,
                :abbreviation,
                :stadium,
                :link

    def initialize(args)
        @team_id = args[:team_id]
        @franchiseid = args[:franchiseid]
        @teamname = args[:teamname]
        @abbreviation = args[:abbreviation]
        @stadium = args[:stadium]
        @link = args[:link]
    end
end
