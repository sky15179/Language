/**
 * @Description: 
 * @Author: 王智刚
 * @Date: 2020-06-01 09:50:42
 * @LastEditTime: 2020-06-01 09:52:40
 * @LastEditors:  
 */

typedef TestBlock = Function();

void beginTest(String name, TestBlock block) {
  print('开始测试模块$name ---------------');
  block();
  print('结束模块$name ---------------');
}