def clear_merge_dir
  merge_dir = "#{vocab_root}/spec/tmp/merge"
  FileUtils.rm_rf( merge_dir ) if File.exists?( merge_dir )
  FileUtils.mkdir_p( merge_dir )
  return merge_dir
end