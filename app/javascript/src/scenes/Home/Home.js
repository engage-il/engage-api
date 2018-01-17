// @flow
import * as React from 'react'
import { createFragmentContainer, graphql } from 'react-relay'
import styled from 'react-emotion'
import { HomeIntro } from './HomeIntro'
import { BillSearch, Button } from '@/components'
import type { Viewer, SearchParams } from '@/types'
import { mixins } from '@/styles'

type Props = {
  viewer: ?Viewer
}

let Home = class Home extends React.Component<*, Props, *> {
  params: SearchParams

  // events
  didChangeParams = (params) => {
    this.params = params
  }

  // lifecycle
  render () {
    const { viewer } = this.props

    return (
      <Scene>
        <HomeIntro />
        <BillSearch
          viewer={viewer}
          onFilter={this.didChangeParams}
        />
        <BillsButton
          to={{
            pathname: '/bills',
            state: {
              params: this.params
            }
          }}
          isSecondary
          children='View All Bills'
        />
      </Scene>
    )
  }
}

Home = createFragmentContainer(Home, graphql`
  fragment HomeScene_viewer on Viewer {
    ...BillSearch_viewer
  }
`)

const Scene = styled.section`
  ${mixins.flexColumn};

  position: relative;
  align-self: center;
`

const BillsButton = styled(Button)`
  align-self: center;
  margin-bottom: 90px;
`

export { Home }
