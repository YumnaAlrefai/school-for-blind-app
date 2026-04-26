<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\Http;


class GreenApiServiceProvider extends ServiceProvider
{
    /**
     * Register services.
     */
    public function register(): void
    {
        $this->app->singleton('greenapi', function () {
            return new class {
                protected $baseUrl;
                protected $instanceId;
                protected $token;

                public function __construct()
                {   
                    $this->baseUrl = config('greenapi.url');
                    $this->instanceId = config('greenapi.instance');
                    $this->token = config('greenapi.token');
                }

                public function sendMessage($phone, $message)
                {
                    $url = "{$this->baseUrl}/waInstance{$this->instanceId}/SendMessage/{$this->token}";

                    return Http::withOptions(['verify' => false])->post($url, [
                        'chatId' => $phone . '@c.us',
                        'message' => $message,
                    ]);
                }
            };
        });

    }

    /**
     * Bootstrap services.
     */
    public function boot(): void
    {
        //
    }
}
