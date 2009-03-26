//
// Copyright (c) 2009, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   26 Mar 09  Brian Frank  Creation
//

**
** Controller for a group of actors which manages their execution.
**
const class ActorGroup
{

  **
  ** Return true if this group has been stopped or killed.  Once a
  ** a group is stopped, messages may not be delivered to any of its
  ** actors.  A stopped group is not necessarily done until all its
  ** actors have finished processing.  Also see `isDone` and `join`.
  **
  Bool isStopped()

  **
  ** Return true if this group has been stopped or killed and all
  ** its actors have completed processing.  If this group was stopped
  ** then true indicates that all pending messages in the queues before
  ** the stop have been fully processed.  If this group was killed,
  ** then this method returns true once all actors have exited their
  ** thread.  See `join` to block until done.
  **
  Bool isDone()

  **
  ** Perform an orderly shutdown.  Once stopped, no new messages
  ** may be sent to this group's actors.  However, any pending
  ** messages will be processed.  Use `join` to wait for all actors
  ** to complete their message queue.  To perform an immediate shutdown
  ** use `kill`.  If the group has already been stopped, then do
  ** nothing.  Return this.
  **
  This stop()

  **
  ** Perform an unorderly shutdown.  Any pending messages which have
  ** not started processing are cancelled.  Actors which are currently
  ** processing a message will be interrupted.  See `stop` to perform
  ** an orderly shutdown.  If the group as already been killed,
  ** then do nothing.
  **
  This kill()

  **
  ** Wait for this group's actors to fully terminate or the until the
  ** given timeout occurs.  A null timeout blocks forever.  If this
  ** method times out, then TimeoutErr is thrown.  Return this.
  **
  This join(Duration? timeout := null)

}