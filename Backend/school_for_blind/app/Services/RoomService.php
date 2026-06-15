<?php

namespace App\Services;

use Agence104\LiveKit\AccessToken;
use Agence104\LiveKit\AccessTokenOptions;
use Agence104\LiveKit\RoomServiceClient;
use Agence104\LiveKit\VideoGrant;
use Livekit\ParticipantPermission;

class RoomService
{
 protected $svc;

 public function __construct()
 {
  $this->svc = new RoomServiceClient(
   config('livekit.url'),
   config('livekit.api_key'),
   config('livekit.api_secret')
  );
 }
 public function generateToken($user, $roomName, $role, $canPublish = false, $isCreator = false)
 {
  $userName = ($role === 'Teacher' || $role === 'Student') ? $user->full_name : $user->name;
  $identity = $role . '--' . $user->id;

  $tokenOptions = (new AccessTokenOptions())
   ->setIdentity($identity)
   ->setName($userName)
   ->setMetadata(json_encode(['role' => $role]));

  $videoGrant = (new VideoGrant())
   ->setRoomJoin(true)
   ->setRoomName($roomName)
   ->setRoomAdmin($isCreator)
   ->setCanPublish($canPublish)
   ->setCanSubscribe(true);

  return (new AccessToken(config('livekit.api_key'), config('livekit.api_secret')))
   ->init($tokenOptions)->setGrant($videoGrant)->toJwt();
 }
 public function kickParticipant($roomName, $targetIdentity)
 {
  $this->svc->removeParticipant($roomName, $targetIdentity);
 }
 public function muteParticipant($roomName, $targetIdentity, $trackSid)
 {
  $this->svc->mutePublishedTrack($roomName, $targetIdentity, $trackSid, true);

  $permissions = new ParticipantPermission();
  $permissions->setCanPublish(false)->setCanSubscribe(true);
  $this->svc->updateParticipant($roomName, $targetIdentity, null, $permissions);
 }
 public function unmuteParticipant($roomName, $targetIdentity)
 {
  $permissions = new ParticipantPermission();
  $permissions->setCanPublish(true)->setCanSubscribe(true);
  $this->svc->updateParticipant($roomName, $targetIdentity, null, $permissions);
 }
 public function endCall($roomName)
 {
  $this->svc->deleteRoom($roomName);
 }
}