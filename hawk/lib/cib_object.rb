#======================================================================
#                        HA Web Konsole (Hawk)
# --------------------------------------------------------------------
#            A web-based GUI for managing and monitoring the
#          Pacemaker High-Availability cluster resource manager
#
# Copyright (c) 2011 Novell Inc., Tim Serong <tserong@novell.com>
#                        All Rights Reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it would be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# Further, this software is distributed without any warranty that it is
# free of the rightful claim of any third person regarding infringement
# or the like.  Any license provided herein, whether implied or
# otherwise, applies only to this software file.  Patent licenses, if
# any, provided herein do not apply to combinations of this program with
# other software, or any other product whatsoever.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write the Free Software Foundation,
# Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
#
#======================================================================

# Shim to get similar behaviour as ActiveRecord

class CibObject

  class CibObjectError < StandardError
  end

  class RecordNotFound < CibObjectError
  end
  
  class PermissionDenied < CibObjectError
  end

  # Need this to behave like an instance of ActiveRecord
  attr_reader :id
  def to_param
    (id = self.id) ? id.to_s : nil
  end

  def new_record?
    @new_record || false
  end

  def errors
    @errors ||= []
  end

  class << self
    # Check whether anything with the given ID exists (not just resources)
    def id_exists?(id)
      # TODO(must): sanitize ID
      %x[/usr/sbin/cibadmin -Ql --xpath '//configuration//*[@id="#{id}"]' 2>/dev/null].chomp != '<null>'
    end
  end

  protected

  def error(msg)
    @errors ||= []
    @errors << msg
  end

end
