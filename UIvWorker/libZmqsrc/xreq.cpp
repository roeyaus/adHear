/*
    Copyright (c) 2007-2011 iMatix Corporation
    Copyright (c) 2007-2011 Other contributors as noted in the AUTHORS file

    This file is part of 0MQ.

    0MQ is free software; you can redistribute it and/or modify it under
    the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation; either version 3 of the License, or
    (at your option) any later version.

    0MQ is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "zmq.h"

#include "xreq.hpp"
#include "err.hpp"

zmq::xreq_t::xreq_t (class ctx_t *parent_, uint32_t tid_) :
    socket_base_t (parent_, tid_),
    fq (this),
    lb (this)
{
    options.type = ZMQ_XREQ;
    options.requires_in = true;
    options.requires_out = true;
}

zmq::xreq_t::~xreq_t ()
{
}

void zmq::xreq_t::xattach_pipes (class reader_t *inpipe_,
    class writer_t *outpipe_, const blob_t &peer_identity_)
{
    zmq_assert (inpipe_ && outpipe_);
    fq.attach (inpipe_);
    lb.attach (outpipe_);
}

void zmq::xreq_t::process_term (int linger_)
{
    fq.terminate ();
    lb.terminate ();
    socket_base_t::process_term (linger_);
}

int zmq::xreq_t::xsend (zmq_msg_t *msg_, int flags_)
{
    return lb.send (msg_, flags_);
}

int zmq::xreq_t::xrecv (zmq_msg_t *msg_, int flags_)
{
    return fq.recv (msg_, flags_);
}

bool zmq::xreq_t::xhas_in ()
{
    return fq.has_in ();
}

bool zmq::xreq_t::xhas_out ()
{
    return lb.has_out ();
}

