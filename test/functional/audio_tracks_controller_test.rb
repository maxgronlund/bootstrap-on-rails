require 'test_helper'

class AudioTracksControllerTest < ActionController::TestCase
  setup do
    @audio_track = audio_tracks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:audio_tracks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create audio_track" do
    assert_difference('AudioTrack.count') do
      post :create, audio_track: @audio_track.attributes
    end

    assert_redirected_to audio_track_path(assigns(:audio_track))
  end

  test "should show audio_track" do
    get :show, id: @audio_track.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @audio_track.to_param
    assert_response :success
  end

  test "should update audio_track" do
    put :update, id: @audio_track.to_param, audio_track: @audio_track.attributes
    assert_redirected_to audio_track_path(assigns(:audio_track))
  end

  test "should destroy audio_track" do
    assert_difference('AudioTrack.count', -1) do
      delete :destroy, id: @audio_track.to_param
    end

    assert_redirected_to audio_tracks_path
  end
end
