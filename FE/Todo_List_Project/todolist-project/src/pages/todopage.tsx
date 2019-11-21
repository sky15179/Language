import React, { Component } from 'react'
import { all } from 'q'

enum FilterType {
  all = 0,
  active,
  completed
}

class TodoPage extends Component<{}, { todoList: RowProps[]; filterType: FilterType }> {
  constructor(props: any) {
    super(props)
    this.state = {
      todoList: [],
      filterType: FilterType.all
    }
  }

  footerOnClick = (index: number) => {
    let type = this.numberToType(index)
    if (type != null) {
      this.setState({ todoList: this.state.todoList, filterType: type })
    }
  }

  filterList = () => {
    let list = this.state.todoList
    let type = this.state.filterType
    switch (type) {
      case FilterType.all:
        return list
      case FilterType.completed:
        return list.filter((value, index) => {
          return value.completed
        })
      case FilterType.active:
        return list.filter((value, index) => {
          return !value.completed
        })
    }
  }

  numberToType(n: number) {
    switch (n) {
      case 0:
        return FilterType.all
      case 1:
        return FilterType.active
      case 2:
        return FilterType.completed
      default:
        return null
    }
  }

  addTodo = (text: string) => {
    let newTodo = { completed: false, text: text, onClick: this.todoOnClick, index: this.state.todoList.length + 1 }
    let newList = this.state.todoList.concat([newTodo])
    this.setState({
      todoList: newList,
      filterType: this.state.filterType
    })
  }

  todoOnClick = (index: number) => {
    let newList = this.state.todoList.slice()
    newList[index].completed = true
    this.setState({
      todoList: newList,
      filterType: this.state.filterType
    })
  }

  render() {
    return (
      <div style={{ marginLeft: 20 }}>
        <TodoInput addTodo={this.addTodo}></TodoInput>
        <TodoList todoList={this.filterList()} todoClick={this.todoOnClick}/>>
        <Footer selectedIndex={this.state.filterType} onClick={this.footerOnClick}></Footer>
      </div>
    )
  }
}

interface RowProps {
  completed: boolean
  text: string
  onClick: (index: number) => void
  index: number
}

function TodoRow(props: RowProps) {
  return (
    <li
      key={'RowProps' + props.index}
      onClick={() => {
        props.onClick(props.index)
      }}
      style={{ textDecoration: props.completed ? 'line-through' : 'none' }}>
      {props.text}
    </li>
  )
}

class TodoList extends Component<{ todoList: RowProps[]; todoClick: (index: number) => void }> {
  renderTodoList = () => {
    return this.props.todoList.map((todo, index) => {
      return TodoRow({ completed: todo.completed, text: todo.text, onClick: this.props.todoClick, index: index })
    })
  }

  render() {
    return <div> {this.renderTodoList()} </div>
  }
}

class TodoInput extends Component<{ addTodo: (text: string) => void }> {

  input: any

  render() {
    return (
      <div style={{ height: 50, alignItems: 'center', flexDirection: 'row', display: 'flex' }}>
          <input type="text" size={10} style={{ width: 200 }} ref={ node => this.input = node } />
          <button style={{ width: 50 }} onClick={ () => { 
            this.props.addTodo(this.input.value)
            this.input.value = ''
           } } >添加</button>
      </div>
    )
  }
}

class Footer extends Component<{ selectedIndex: number; onClick: (index: number) => void }> {
  constructor(props: any) {
    super(props)
  }

  render() {
    return (
      <div style={{ display: 'inline' }}>
        <span>
          筛选：
          {[FilterType.all, FilterType.active, FilterType.completed].map((type, index) => {
            return this.renderButton(type)
          })}
        </span>
      </div>
    )
  }

  renderButton(i: number) {
    let content = ''
    switch (i) {
      case 0:
        content = '全部'
        break
      case 1:
        content = '进行中'
        break
      case 2:
        content = '已完成'
        break
      default:
        break
    }
    return FooterBtn(this.props.selectedIndex == i, this.props.onClick, content, i)
  }
}

function FooterBtn(active: boolean, onClick: (num: number) => void, content: string, index: number) {
  return (
    <button
      key={'FooterBtn' + index}
      disabled={active}
      onClick={() => {
        onClick(index)
      }}
      style={{ marginLeft: 4 }}>
      {content}
    </button>
  )
}

export default TodoPage
