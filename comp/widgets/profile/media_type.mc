<%doc>
###############################################################################

=head1 NAME

/widgets/profile/media_type.mc - Processes submits from Media Types Profile

=head1 VERSION

$Revision: 1.2.4.2 $

=head1 DATE

$Date: 2003-07-02 19:35:51 $

=head1 SYNOPSIS

  $m->comp('/widgets/profile/media_type.mc', %ARGS);

=head1 DESCRIPTION

This element is called by /widgets/profile/callback.mc when the data to be
processed was submitted from the Media Types Profile page.

=cut

</%doc>
<%once>;
my $type = 'media_type';
my $disp_name = get_disp_name($type);
my $class = get_package_name($type);
</%once>
<%args>
$widget
$param
$field
$obj
</%args>
<%init>;
return unless $field eq "$widget|save_cb";

# Instantiate the media_type object and grab its name.
my $mt = $obj;
my $name = $param->{name};
my $qname = "&quot;$name&quot;";

# If 'delete' box is checked, deactivate the Media Type;
# otherwise, save the profile.
if ($param->{delete}) {
    my @old_exts = $mt->get_exts();
    $mt->del_exts(@old_exts);
    $mt->deactivate;
    $mt->save;
    log_event("${type}_deact", $mt);
    add_msg($lang->maketext("$disp_name profile [_1] deleted.",$qname));
    set_redirect("/admin/manager/$type");
    return;
} else {
    my $mt_id = $param->{"${type}_id"};

    # Make sure the name isn't already taken.
    my $used = 0;
    unless (defined $name && $name =~ /\S/) {
	# Should $meths->{name}{req} == 1 in Bric::Util::MediaType ?
	add_msg('Name is required.');
	$used = 1;
    } else {
        my @mts = ($class->list_ids({ name => $name }),
                   $class->list_ids({ name => $name, active => 0 }) );
        $used = 1 if (@mts > 1)
            || (@mts == 1 && !defined $mt_id)
            || (@mts == 1 && defined $mt_id && $mts[0] != $mt_id);
        add_msg($lang->maketext("The name [_1] is already used by another $disp_name.",$qname)) if $used;
    }

    # Process add_more widget.
    my (@old_exts, @new_exts, $mtids, $used_ext, $addext_sub);
    @old_exts = $mt->get_exts();
    $mtids = mk_aref($param->{media_type_ext_id});
    $used_ext = 0;
    $addext_sub = sub {
	my ($mt, $extension, $name) = @_;
	my $usedext = 0;
	unless ($extension =~ /^\s*$/) {
	    if ($extension =~ /^\w{1,10}$/) {
		my $mt_name = Bric::Util::MediaType->get_name_by_ext($extension);
		if (defined $mt_name && $mt_name ne $name) {
		    $usedext = 1;
		    add_msg("Extension '$extension' is already used by media type '$mt_name'.");
		} else {
		    unless ($mt->add_exts($extension)) {
                        add_msg($lang->maketext("Problem adding [_1]","'$extension'"));
		    }
		}
	    } else {
                add_msg($lang->maketext("Extension [_1] ignored.","'$extension'"));
	    }
	}
	return $usedext;
    };

    $used_ext = 0;
    for (my $i = 0; $i < @{$param->{extension}}; $i++) {
	if (my $ext = $mtids->[$i]) {
            next;
	} else {
	    next unless $param->{extension}[$i];
	    my $extension = $param->{extension}[$i];
	    $used_ext += $addext_sub->($mt, $extension, $name);
	}
    }
    if ($param->{del_media_type_ext}) {
	$mt->del_exts(@{ mk_aref($param->{del_media_type_ext}) });
    }

    @new_exts = $mt->get_exts();
    unless (@new_exts) {
	# Revert the extensions
	$mt->add_exts(@old_exts);
	add_msg('At least one extension is required.');
	$used_ext = 1;
    }

    # Roll in the changes.
    $mt->set_name($name) unless $used;
    $mt->set_description($param->{description});

    # Save changes and redirect back to the manager.
    if ($used || $used_ext) {
	return $mt;
    } else {
	$mt->activate();
	$mt->save();
        add_msg($lang->maketext("$disp_name profile [_1] saved",$qname));
	unless (defined $mt_id) {
	    log_event($type . '_new', $mt);
	} else {
	    log_event($type . '_save', $mt);
	}
	set_redirect("/admin/manager/$type");
	return;
    }
}
</%init>