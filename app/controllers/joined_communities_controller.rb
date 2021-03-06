class JoinedCommunitiesController < ApplicationController

  def index
    # if there's a user that's logged in
    if current_user
      # Show the user the communities they've joined
      render json: current_user.joined, status: :ok
    else
      # Tell them they need to sign in to see the communities they've joined
      render json: { message: "You must be logged in to perform this action!!"}, status: :unauthorized
    end
  end

  def create
    # if there's a user that's logged in
    if current_user
      # create a joined community
      jc = current_user.joined_communities.create(joined_community_params)
      # if it was joined successfully
      if jc.valid?
        # tell the user
        render json: jc, status: :ok
      else
        # Tell the user that something went wrong
        render json: { errors: jc.errors.full_messages }, status: :bad_request
      end
    else
      # Tell them they need to sign in to join a community
      render json: { message: "You must be logged in to perform this action!!"}, status: :unauthorized
    end
  end

  def destroy
    # if there's a user that's logged in
    if current_user
      joined_community = JoinedCommunity.find_by(user_id: current_user.id, community_id: params["community_id"])
      # If we found the right community
      if joined_community
        # destroy the joined_community
        joined_community.destroy
        # render
        render json: { message: "#{current_user.username} has left ../#{joined_community.community.name}"}
      else
        # Tell the user something went wrong
        render json: { message: "Something went wrong!", errors: ["You can't leave a community that you haven't joined.", "You might be trying to leave the wrong community."]}, status: :bad_request
      end
    else
      # Tell them they need to sign in to leave a community
      render json: { message: "You must be logged in to perform this action!!"}, status: :unauthorized
    end
  end

  private

  def joined_community_params
    params.permit(:community_id)
  end

end
