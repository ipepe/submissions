# encoding: UTF-8
class AudienceLevelsController < ApplicationController
  skip_before_filter :authenticate_user!, only: %i(index)

  def index
    @audience_levels = resource_class.for_conference(@conference).includes(:translated_contents)
  end

  def create
    @audience_level = resource_class.new(audience_level_params)
    if @audience_level.save
      flash[:notice] = t('flash.audience_level.create.success')
      redirect_to conference_audience_levels_path(@conference)
    else
      @new_track = Track.new(conference: @conference)
      @new_session_type = SessionType.new(conference: @conference)
      @new_audience_level = @audience_level
      @conference.supported_languages.each do |code|
        @new_track.translated_contents.build(language: code)
        @new_session_type.translated_contents.build(language: code)
        @new_audience_level.translated_contents.build(language: code)
      end
      flash.now[:error] = 'Something went wrong'
      render template: 'conferences/edit'
    end
  end

  def update
    @audience_level = resource_class.where(id: params[:id]).first
    if @audience_level.update_attributes(audience_level_params)
      flash[:notice] = t('flash.audience_level.update.success')
      redirect_to conference_audience_levels_path(@conference)
    else
      @new_track = Track.new(conference: @conference)
      @new_session_type = SessionType.new(conference: @conference)
      @new_audience_level = @audience_level
      @conference.supported_languages.each do |code|
        @new_track.translated_contents.build(language: code)
        @new_session_type.translated_contents.build(language: code)
        @new_audience_level.translated_contents.build(language: code)
      end
      flash.now[:error] = 'Something went wrong'
      render template: 'conferences/edit'
    end
  end

  protected
  def resource_class
    AudienceLevel
  end

  def audience_level_params
    attrs = params.require(:audience_level).permit(translated_contents_attributes: [:language, :title, :description])
    attrs.merge(conference_id: @conference.id)
  end
end
