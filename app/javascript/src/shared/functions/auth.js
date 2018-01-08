// @flow
import { Base64 } from 'js-base64'
import { session } from 'shared/storage'
import { events } from 'shared/events'

export function isSignedIn () {
  return !!session.get('admin-header')
}

export function signIn (username: string, password: string) {
  const authValue = Base64.encode(`${username}:${password}£`)
  const authHeader = `Basic ${authValue}`
  session.set('admin-header', authHeader)
  events.emit(events.setAuthHeader, authHeader)
}

export function signOut () {
  session.set('admin-header', null)
  events.emit(events.setAuthHeader, null)
}
