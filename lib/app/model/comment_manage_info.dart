class CommentManageInfo {
	int commentPermissionType;
	int approvalCommentType;

	CommentManageInfo({this.commentPermissionType, this.approvalCommentType});

	CommentManageInfo.fromJson(Map<String, dynamic> json) {
		commentPermissionType = json['comment_permission_type'];
		approvalCommentType = json['approval_comment_type'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['comment_permission_type'] = this.commentPermissionType;
		data['approval_comment_type'] = this.approvalCommentType;
		return data;
	}
}