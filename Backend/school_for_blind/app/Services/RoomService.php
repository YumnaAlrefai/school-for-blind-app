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
    $userName = (($role === 'Student') ? $user->fullname : (($role === 'Teacher') ? $user->full_name : $user->role));
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

  public function muteParticipant($roomName, $targetIdentity, $trackSid = null)
  {
    // 1. إذا كان المايك شغال وعنده مسار صوتي، نكتمه فوراً
    if (!empty($trackSid)) {
      try {
        $this->svc->mutePublishedTrack($roomName, $targetIdentity, $trackSid, true);
      } catch (\Exception $e) {
        // نتجاهل الخطأ إذا المسار غير موجود، ونكمل لسحب الصلاحيات
      }
    }

    // 2. سحب صلاحية التحدث (حتى لو كان المايك مغلق)
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