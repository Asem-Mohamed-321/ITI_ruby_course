class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.persisted?
      # Users can manage (read/edit/delete) their own articles
      can :manage, Article, user_id: user.id

      # Users can read any article
      can :read, Article

      # Users can report others' articles
      can :report, Article do |article|
        article.user_id != user.id
      end
    else
      # Guests can only read public articles
      can :read, Article
    end
  end
end
