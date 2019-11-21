import React from 'react';
import { Card, Typography, Alert, List, Row, Col } from 'antd';
import { PageHeaderWrapper } from '@ant-design/pro-layout';
import { FormattedMessage } from 'umi-plugin-react/locale';
import styles from './style.less';

class MYCard extends React.PureComponent {
  render() {
    return <div className=""></div>;
  }
}

interface CardProps {
  children: React.ReactNode;
}

interface TaskListProps {
  loading: boolean;
  list: TaskListModel[];
}

interface TaskListState {
  visible: boolean;
  current?: Partial<TaskListModel>;
}

interface TaskListModel {
  name: string;
}

const fakeList: TaskListModel[] = [{ name: '1' }, { name: '1' }, { name: '1' }, { name: '1' }];

export default class TaskList extends React.PureComponent {
  render() {
    const loading = false;
    return (
      <PageHeaderWrapper>
        <Card>
          <Card bordered={false}>
            <Row>
              <Col sm={8} xs={24}>
                <p>我的待办</p>
              </Col>
              <Col sm={8} xs={24}>
                <p>本周任务平均处理时间</p>
              </Col>
              <Col sm={8} xs={24}>
                <p>本周完成任务数</p>
              </Col>
            </Row>
          </Card>
          <Alert
            message="umi ui 现已发布，欢迎使用 npm run ui 启动体验。"
            type="success"
            showIcon
            banner
            style={{
              margin: -12,
              marginBottom: 24,
            }}
          />
          <Typography.Text strong>
            <a target="_blank" rel="noopener noreferrer" href="https://pro.ant.design/docs/block">
              <FormattedMessage
                id="app.welcome.link.block-list"
                defaultMessage="基于 block 开发，快速构建标准页面"
              />
            </a>
          </Typography.Text>
          <Typography.Text
            strong
            style={{
              marginBottom: 12,
            }}
          >
            <a
              target="_blank"
              rel="noopener noreferrer"
              href="https://pro.ant.design/docs/available-script#npm-run-fetchblocks"
            >
              <FormattedMessage id="app.welcome.link.fetch-blocks" defaultMessage="获取全部区块" />
            </a>
          </Typography.Text>
        </Card>
        <Card
          title="列表"
          bordered={false}
          className={styles.listCard}
          style={{ marginTop: 24 }}
          bodyStyle={{ padding: '0 32px 40px 32px' }}
        >
          <List
            rowKey="id"
            size="large"
            loading={loading}
            dataSource={fakeList}
            renderItem={item => (
              <List.Item
                actions={[
                  <a
                    key="edit"
                    onClick={e => {
                      e.preventDefault();
                    }}
                  >
                    编辑
                  </a>,
                ]}
              >
                <List.Item.Meta title={<p>测试</p>} description="测试内容太" />
              </List.Item>
            )}
          ></List>
        </Card>
        <p style={{ textAlign: 'center', marginTop: 24 }}>
          Want to add more pages? Please refer to{' '}
          <a href="https://pro.ant.design/docs/block-cn" target="_blank" rel="noopener noreferrer">
            use block
          </a>
          。
        </p>
      </PageHeaderWrapper>
    );
  }
}
