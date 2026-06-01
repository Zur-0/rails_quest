class Quest2StudentService
  class << self
    # @return [String]
    def all_agents
      Agent.order(:codename).pluck(:codename).join("\n")
    end

    # @return [String]
    def all_missions
      Mission.order(:title).pluck(:title).join("\n")
    end

    # @return [String]
    def agents_with_missions
       Agent
    .includes(:missions)
    .order(:codename)
    .map { |agent| "#{agent.codename}: #{agent.missions.order(:title).pluck(:title).join(', ')}" }
    .join("\n")
    end

    # @return [String]
    def agents_with_missions_sorted_by_mission_count
       Agent
    .includes(:missions)
    .sort_by { |agent| [-agent.missions.size, agent.codename] }
    .map { |agent| "#{agent.codename} (#{agent.missions.size}): #{agent.missions.order(:title).pluck(:title).join(', ')}" }
    .join("\n")
    end

    # @return [String]
    def agents_with_skills
       Agent
    .includes(:skills)
    .order(:codename)
    .map { |agent| "#{agent.codename}: #{agent.skills.order(:name).pluck(:name).join(', ')}" }
    .join("\n")
    end

    # @return [String]
    def skills_by_agent_count
       Skill
    .includes(:agents)
    .sort_by { |skill| [-skill.agents.size, skill.name] }
    .map { |skill| "#{skill.name} (#{skill.agents.size}): #{skill.agents.order(:codename).pluck(:codename).join(', ')}" }
    .join("\n")
    end
  end
end
