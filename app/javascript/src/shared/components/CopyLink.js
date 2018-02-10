// @flow
import * as React from 'react'
import Clipboard from 'react-copy-to-clipboard'
import { Link } from './Link'
import { events } from '@/events'

type Props = {
  value: string
}

export class CopyLink extends React.Component<Props> {
  // events
  didCopyValue = (text: string) => {
    events.emit(events.showNotification, {
      key: 'copy-link',
      message: 'Copied link to clipboard ✔'
    })
  }

  // lifecycle
  render () {
    const { value } = this.props

    return (
      <Clipboard text={value} onCopy={this.didCopyValue}>
        <Link onClick={() => {}}>
          <span>Copy Link</span>
        </Link>
      </Clipboard>
    )
  }
}
