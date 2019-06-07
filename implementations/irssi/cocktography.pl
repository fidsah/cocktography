#########
# Cocktography v1.0 for irsii 
# by the Fraternal Order of the Friends of the Penis
# MIT license shit or whatever, idk, go nuts


use strict;
use warnings;
use Cocktography2;
use Irssi;
use Irssi::TextUI;
use Encode;
use vars qw($VERSION %IRSSI);

my $cock = Cocktography2::new();
my %buffer; 
my $rooster = "\N{U+1f413}";
my $eggplant = "\N{U+1f346}";

$VERSION = "1.0"; 

%IRSSI = (
    authors     => "fidsah" .
                   "jeian" .
                   "tefad",
    contact     => 'github/fofp',
    patchers    => '',
    name        => 'cocktography',
    description => 'Cummunicate in secret, using dicks!',
    license     => 'MIT',
    url         => 'https://github.com/fofp',
    commands    => 'enchode',
);



sub irsii_enchode($$) {

	my ($input, $server, $window) = @_;
	my $strokes;
	my $mode;
	my $text;
	my $color;
	my $glyph;
	
	if ($input =~ /(?:[-\\\/]s(?:troke)?[\s:]?(\d+)\s|[-\\\/]m(?:ode)?[\s:]?([twm])\s)*(.*)/){
		$strokes = $1;
		$mode = $2;
		$text = $3;
	}
	if (not defined $strokes) {
		$strokes = 2;
	}
	if (not defined $mode) {
		$mode = 't'; 
	}
		
	
	my %modes = ('t' => 1, 'w' => 2, 'm' =>3);
	my $fatone = Cocktography2->enchode_string($text,$strokes,$modes{$mode},280);
    
	
	my @dicks = split("\n",$fatone);
	if ($strokes > 0) {
			$color = 4; 
			$glyph = $eggplant;
    } else {
			$color = 3;
			$glyph = $rooster; 
	} 
	foreach my $dick (@dicks){
	
		$window->command("MSG " . $window->{name}. " " . $dick);
	}
	
	
	$server->print( $window->{name}, '<' . $color . '' . $strokes . $glyph. $server->{nick} . '> ' . $text, MSGLEVEL_MSGS);
	Irssi::signal_stop();
}
sub irsii_dechode($$) {
	my ($dicks) = @_;
	my $fatone = Cocktography2->dechode_string($dicks);
	#print $fatone;
	

}

sub event_privmsg {

	my ($server, $data, $nick, $address) = @_;
	my ($target, $text) = split(/ :/, $data, 2);
	my $key = $nick . $target;
	my @boner = Cocktography2->find_cockblocks($text);

	if (not defined  $boner[0][0]) {
	return;
	}
    my $message;
	my $color;
	my $glyph;
#("SINGLETON" => 1, "INITIAL" => 2, "INTERMEDIATE" => 3, "FINAL" => 4);
	if ($boner[0][0]{"TYPE"} == 1) {
		$message = Cocktography2->dechode_string($text);
		if ($message->{'strokes'} > 0) {
			$color = 4; 
			$glyph = $eggplant;
		} else {
			$color = 0;
			$glyph = $rooster;
		} 
		print $message->{'message'};
		$server->print($target, '<' . $color . '' . $message->{'strokes'} . $glyph. $nick . '> ' . $message->{'message'}, MSGLEVEL_MSGS);
		Irssi::signal_stop();
	}
	
	if ($boner[0][0]{"TYPE"} == 2) {
	    $buffer{$key} = $text;
		Irssi::signal_stop();
	}
	
	if ($boner[0][0]{"TYPE"} == 3) {
	    $buffer{$key} = $buffer{$key} . ' ' . $text;
		Irssi::signal_stop();
	}
	
	if ($boner[0][0]{"TYPE"} == 4) {

	    $buffer{$key} = $buffer{$key} . ' ' . $text;
		$message = Cocktography2->dechode_string($buffer{$key});
				
		if ($message->{'strokes'} > 0) {
			$color = 4; 
			$glyph = $eggplant;
		} else {
			$color = 3;
			$glyph = $rooster; 
		} 
		
		$server->print($target, '<' . $color . '' . $message->{'strokes'} . $glyph . $nick . '> ' . $message->{'message'} , MSGLEVEL_MSGS);
		delete $buffer{$key};
		Irssi::signal_stop();
		
	}
	
}

Irssi::command_bind('enchode'      => 'irsii_enchode');
Irssi::command_bind('dechode'      => 'irsii_dechode');
Irssi::signal_add("event privmsg", "event_privmsg");
