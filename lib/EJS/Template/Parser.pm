use 5.006;
use strict;
use warnings;

=head1 NAME

EJS::Template::Parser - Parser module for EJS::Template

=cut

package EJS::Template::Parser;
use base 'EJS::Template::Base';

use EJS::Template::IO;
use EJS::Template::Parser::Context;

=head1 Methods

=head2 parse

Parses EJS source and generates JavaScript code.

    $parser->parser($input, $output);

The C<$input> is used as the EJS source code, and the generated JavaScript code
is written out to C<$output>.

=cut

sub parse {
    my ($self, $input, $output) = @_;
    my ($in, $in_close) = EJS::Template::IO->input($input);
    
    my $context;
    
    eval {
        $context = EJS::Template::Parser::Context->new($self->config);
        
        while (my $line = <$in>) {
            $line =~ s/\r+\n?$/\n/;
            $context->read_line($line);
        }
    };
    
    my $e = $@;
    close $in if $in_close;
    die $e if $e;
    
    my ($out, $out_close) = EJS::Template::IO->output($output);
    
    eval {
        print $out $_ foreach @{$context->result};
    };
    
    $e = $@;
    close $out if $out_close;
    die $e if $e;
    
    return 1;
}

=head1 SEE ALSO

=over 4

=item * L<EJS::Template>

=back

=cut

1;
