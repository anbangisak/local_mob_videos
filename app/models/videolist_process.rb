class VideolistProcess < ActiveRecord::Base
  require 'find'

  def system_videos_list
    home_vid_list_str = "find /home/ -type f -exec file -N -i -- {} + | sed -n 's!: video/[^:]*$!!p'"
    media_vid_list_str = "find /media/ -type f -exec file -N -i -- {} + | sed -n 's!: video/[^:]*$!!p'"

    home_vid_list_pid = Process.spawn(home_vid_list_str)
    media_vid_list_pid = Process.spawn(media_vid_list_str)
  end

  def self.video_lists(search_base="/home/")
    # '/home/' , '/media/'
    begin
      Timeout::timeout(1800) do
        Find.find(search_base) do |path|
          name = path.split("/").last if path.split("/").last
          path_details_hash = self.file_video_cond(path)
          vid_list_process = self.find_or_initialize_by(details: path) if path_details_hash[:status]
          if vid_list_process
            vid_list_process.save
            pid_tmp_name = "#{Rails.root}/public/videos/#{name}-#{vid_list_process.id}"
            vid_list_process.update(
              {
                name: name,
                message: path_details_hash[:type],
                pid: pid_tmp_name,
                status: path_details_hash[:content_type],
                hidden: path.include?("/.")
              }
            )
            File.symlink(path, pid_tmp_name)
          end
        end
      end
    rescue Exception => e
      p e.message
      p e.backtrace.inspect
    end
  end

  def self.file_video_cond(file_path)
    type = MIME::Types.type_for("#{file_path}")
    t_list = self.content_types_list
    status = (type.collect {|d| t_list.include?(d.content_type)}).include?(true)
    content_type = (type.collect {
      |d| d.content_type if t_list.include?(d.content_type)
    }).compact.first if status
    p status
    p content_type
    return {status: status, type: type, content_type: content_type}
  end

  def self.content_types_list
    # return keyword no need
    return [
      "application/ogg", "video/ogg", "video/mp4", "video/mov",
      "video/x-flv", "application/x-mpegURL", "video/3gpp", "video/quicktime", "video/flv",
      "video/x-msvideo", "video/x-ms-wmv"
    ]
  end

  def self.destroy_symlinks
    VideolistProcess.delete_all
    FileUtils.rm_rf("#{Rails.root}/public/videos/.", secure: true)
    return true
  end

end
