import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';
import { Link, BrowserRouter as Router, Route } from 'react-router-dom'
import TodoPage from './pages/todopage'
import CSSLearn from './pages/cssLearn'

class App extends Component {
  render() {
    return (
      <Router>
        <Route path="/" exact component={Home}></Route>
        <Route path="/TodoPage" component={TodoPage} />
        <Route path="/Welcome" component={Welcome} />
        <Route path="/CSSLearn" component={CSSLearn} />
      </Router>
    )
  }
}

class Welcome extends Component {
  render() {
    return (
      <div>欢迎</div>
    )
  }
}

class Home extends Component {
  render() {
    return (
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <p>
            Edit <code>src/App.tsx</code> and save to reload.
          </p>
          <a className="App-link" href="https://reactjs.org" target="_blank" rel="noopener noreferrer">
            Learn React123
          </a>
          <Link to="/" style={{ color: 'black' }}>
            点击跳转home页
          </Link>
          <Link to="/TodoPage" style={{ color: 'black' }}>
            点击跳转todo页
          </Link>
          <Link to="/Welcome" style={{ color: 'black' }}>
            点击跳转welcome页
          </Link>
          <Link to="/CSSLearn" style={{ color: 'black' }}>
            点击跳CSSLearn页
          </Link>
        </header>
      </div>
    )
  }
}

export default App