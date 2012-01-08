class CreateAudioTracks < ActiveRecord::Migration
  def change
    create_table :audio_tracks do |t|
      t.string :title
      t.string :audio_file

      t.timestamps
    end
  end
end
