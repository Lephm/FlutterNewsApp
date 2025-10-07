class PostData{
  const PostData({
    required this.postID,
    required this.postTitle,
    required this.postDescription,
    required this.tag,
});
  final String postID;
  final String postTitle;
  final String postDescription;
  final List<String> tag;
}