package Bric::Util::Priv::Parts::Const;

=head1 NAME

Bric::Util::Priv::Parts::Const - Exports Bricolage Privilege Constants

=head1 VERSION

$Revision: 1.7 $

=cut

# Grab the Version Number.
use Bric; our $VERSION = Bric->VERSION;

=head1 DATE

$Date: 2003/12/22 03:21:16 $

=head1 SYNOPSIS

  use Bric::Util::Priv::Parts::Const qw(:all);

=head1 DESCRIPTION

Exports Privilege constants. Those constants are:

=over 4

=item *

READ

=item *

EDIT

=item *

RECALL - Used only for assets.

=item *

CREATE

=item *

PUBLISH - Used only for assets.

=item *

DENY

=back

=cut

################################################################################
# Dependencies
################################################################################
# Standard Dependencies
use strict;

################################################################################
# Programmatic Dependences

################################################################################
# Inheritance
################################################################################
use base qw(Exporter);

# You can explicitly import any of the functions in this class.
our @EXPORT_OK = qw(READ EDIT RECALL CREATE PUBLISH DENY);

# But you'll generally just want to import all of them at once.
our %EXPORT_TAGS = (all => \@EXPORT_OK);

################################################################################
# Function Prototypes
################################################################################
# NONE.

################################################################################
# Constants
################################################################################
use constant READ => 1;
use constant EDIT => 2;
use constant RECALL => 3;
use constant CREATE => 4;
use constant PUBLISH => 5;
use constant DENY => 255;

################################################################################
# Fields
################################################################################
# Public Class Fields

################################################################################
# Private Class Fields

################################################################################

################################################################################
# Instance Fields

################################################################################
# Class Methods
################################################################################

=head1 INTERFACE

=head2 Constructors

NONE.

=head2 Destructors

NONE.

=head2 Public Class Methods

NONE.

=head2 Public Instance Methods

NONE.

=head1 PRIVATE

=head2 Private Class Methods

NONE.

=head2 Private Instance Methods

NONE.

=head2 Private Functions

NONE.

=cut

1;
__END__

=head1 NOTES

NONE.

=head1 AUTHOR

David Wheeler <david@wheeler.net>

=head1 SEE ALSO

L<Bric|Bric>,
L<Bric::Util::Priv|Bric::Util::Priv>

=cut
