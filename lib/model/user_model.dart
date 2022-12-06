
/// 用户实体类
class UserModel{

  /// 用户id
  String? userId;
  /// 用户登录名
  String? userName;
  /// 用户姓名
  String? nickName;
  /// 用户头像地址
  String? avatar;
  /// 部门id
  String? deptId;
  /// 部门名称
  String? deptName;
  /// 手机号
  String? phone;
  /// 邮箱
  String? email;
  /// 员工编号
  String? employeeNumber;

  UserModel({this.userId, this.userName, this.nickName, this.avatar, this.deptId,
      this.deptName, this.phone, this.email, this.employeeNumber});

  @override
  String toString() {
    return 'UserModel{userId: $userId, userName: $userName, nickName: $nickName, avatar: $avatar, deptId: $deptId, deptName: $deptName, phone: $phone, email: $email, employeeNumber: $employeeNumber}';
  }
}